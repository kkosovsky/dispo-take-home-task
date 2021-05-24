import Combine
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

    // MARK: - Private

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchResult>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>

    private lazy var dataSource = makeDataSource()

    private var searchResults: [SearchResult] = []

    private lazy var mainView: MainView = {
        MainView()
    }()

    private var cancellables = Set<AnyCancellable>()
    private let searchTextChangedSubject = PassthroughSubject<String, Never>()

    private func setUpCollectionView() {
        mainView.collectionView.registerCell(MainCollectionViewCell.self)
        mainView.collectionView.dataSource = dataSource
        mainView.searchBar.delegate = self
    }

    private func bindViewModel() {
        let (
            loadResults,
            pushDetailView
        ) = mainViewModel(
            cellTapped: Empty().eraseToAnyPublisher(),
            searchText: searchTextChangedSubject.eraseToAnyPublisher(),
            viewWillAppear: Empty().eraseToAnyPublisher()
        )

        loadResults
            .sink { [weak self] results in
                self?.applySnapshot(with: results)
            }
            .store(in: &cancellables)

        pushDetailView
            .sink { [weak self] result in
                // push detail view
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
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? MainCollectionViewCell

            cell?.gifTextLabel.text = searchResult.text
            cell?.gifImageView.image = UIImage(systemName: "chevron.right")
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
