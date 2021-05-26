import Combine
import Kingfisher
import UIKit

final class MainViewController: UIViewController {

    // MARK: - Lifecycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainView.searchBar
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
    private lazy var mainView: MainView = {
        MainView()
    }()

    private func setUpCollectionView() {
        mainView.collectionView.registerCell(MainCollectionViewCell.self)
        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
        mainView.searchBar.delegate = self
    }

    private func bindViewModel() {
        let input: MainViewModelInput = (
            cellTapped: cellTappedSubject.eraseToAnyPublisher(),
            searchText: searchTextChangedSubject.eraseToAnyPublisher(),
            viewWillAppear: viewWillAppearSubject.eraseToAnyPublisher()
        )

        let output: MainViewModelOutput = input |> liveMainViewModel

        output.loadResults
            .sink { [weak self] results in
                self?.searchResults = results
                self?.applySnapshot(with: results)
            }
            .store(in: &cancellables)

        output.pushDetailView
            .sink { [weak self] result in
                let viewController = DetailViewController(searchResult: result)
                self?.navigationController?.pushViewController(viewController, animated: true)
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

    let downloader = ImageDownloader.default

    let cache = ImageCache.default

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: mainView.collectionView) { (collectionView, indexPath, searchResult) in
            let cell = collectionView.dequeueCell(MainCollectionViewCell.self, for: indexPath)
            cell.gifTextLabel.text = searchResult.text
            if let image = self.cache.retrieveImageInMemoryCache(forKey: searchResult.gifUrl.absoluteString) {
                cell.gifImageView.image = image
                return cell
            }

            cell.downloadTask = self.downloader.downloadImage(with: searchResult.gifUrl) { result in
                switch result {
                case .success(let value):
                    cell.gifImageView.image = value.image
                    self.cache.store(value.image, forKey: searchResult.gifUrl.absoluteString, toDisk: false)
                case .failure(let error):
                    print(error)
                }
            }

            return cell
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


