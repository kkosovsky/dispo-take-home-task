import Combine
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
        bindViewModel()
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
            }
            .store(in: &cancellables)

        pushDetailView
            .sink { [weak self] result in
                // push detail view
            }
            .store(in: &cancellables)
    }

    // MARK: - Private

    private var cancellables = Set<AnyCancellable>()
    private let searchTextChangedSubject = PassthroughSubject<String, Never>()
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextChangedSubject.send(searchText)
    }
}
