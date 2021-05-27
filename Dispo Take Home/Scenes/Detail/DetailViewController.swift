import Combine
import UIKit

final class DetailViewController: UIViewController, NavigationActionProducer {

    // MARK: - NavigationActionProducer

    var action: AnyPublisher<NavigationAction, Never> {
        navigationActionSubject.eraseToAnyPublisher()
    }

    var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(gifId: String) {
        self.gifId = gifId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    private lazy var detailView = DetailView()

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(goBack)
        )

        let output = Just(gifId).eraseToAnyPublisher() |> liveDetailViewModel
        output.sink { [unowned self] gifInfo in
            self.detailView
                |> DetailView.withTitle(gifInfo.title)
                |> DetailView.withShares(gifInfo.shares)
                |> DetailView.withTags(gifInfo.tags)
                |> DetailView.withImage(gifInfo.gifUrl)
        }.store(in: &cancellables)
    }

    // MARK: - Private

    private let gifId: String
    private let navigationActionSubject = PassthroughSubject<NavigationAction, Never>()

    @objc private func goBack() {
        navigationActionSubject.send(.goBack)
    }
}
