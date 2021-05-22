import Combine
import UIKit

class MainViewController: UIViewController {
  private var cancellables = Set<AnyCancellable>()
  private let searchTextChangedSubject = PassthroughSubject<String, Never>()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = searchBar

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
        // load search results into data source
      }
      .store(in: &cancellables)

    pushDetailView
      .sink { [weak self] result in
        // push detail view
      }
      .store(in: &cancellables)
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .systemBackground
    view.addSubview(collectionView)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "search gifs..."
    searchBar.delegate = self
    return searchBar
  }()

  private var layout: UICollectionViewLayout {
    // TODO: implement
    fatalError()
  }

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    collectionView.backgroundColor = .clear
    collectionView.keyboardDismissMode = .onDrag
    return collectionView
  }()
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchTextChangedSubject.send(searchText)
  }
}
