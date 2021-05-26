import Combine
import Kingfisher
import UIKit

final class MainViewController: UIViewController {

    // MARK: - Lifecycle

    private lazy var mainView: MainView = {
        MainView()
    }()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainView.searchBar
        mainView.searchBar.delegate = self
        setUpCollectionView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.send(())
    }

    // MARK: - Private

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchResult>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>
    private let searchTextChangedSubject = PassthroughSubject<String, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let cellTappedSubject = PassthroughSubject<SearchResult, Never>()
    private var searchResults: [SearchResult] = []
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()

    private func setUpCollectionView() {
        mainView.collectionView.registerCell(MainCollectionViewCell.self)
        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
        mainView.collectionView.prefetchDataSource = self
    }

    private func bindViewModel() {
        let input: MainViewModelInput = (
            cellTapped: cellTappedSubject.eraseToAnyPublisher(),
            searchText: searchTextChangedSubject.eraseToAnyPublisher(),
            viewWillAppear: viewWillAppearSubject.eraseToAnyPublisher()
        )

        let output: MainViewModelOutput = input |> liveMainViewModel

        output.loadResults
            .sink { [unowned self] results in
                self.searchResults = results
                self.applySnapshot(with: results)
            }
            .store(in: &cancellables)

        output.pushDetailView
            .sink { [unowned self] result in
                let viewController = DetailViewController(searchResult: result)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &cancellables)
    }

    private func applySnapshot(with items: [SearchResult]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach {
            snapshot.appendItems(items, toSection: $0)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: mainView.collectionView) { (collectionView, indexPath, searchResult) in
            collectionView.dequeueCell(MainCollectionViewCell.self, for: indexPath)
                |> MainCollectionViewCell.withTitle(searchResult.text)
                |> MainCollectionViewCell.withImage(
                searchResult.gifUrl,
                cache: ImageCache.default,
                downloader: ImageDownloader.default
            )
        }
    }
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextChangedSubject.send(searchText)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTappedSubject.send(searchResults[indexPath.item])
    }
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = searchResults.map { $0.gifUrl }
        ImagePrefetcher(urls: urls).start()
    }
}


