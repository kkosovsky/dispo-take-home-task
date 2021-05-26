import Combine
import UIKit

final class DetailViewController: UIViewController {

    // MARK: - Initialization

    init(searchResult: SearchResult) {
        self.searchResult = searchResult
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
        let output = Just(searchResult).eraseToAnyPublisher() |> liveDetailViewModel
        output.sink { [unowned self] gifInfo in
            self.detailView
                |> DetailView.withTitle(gifInfo.title)
                |> DetailView.withShares(gifInfo.shares)
                |> DetailView.withTags(gifInfo.tags)
                |> DetailView.withImage(gifInfo.gifUrl)
        }.store(in: &cancellables)
    }

    // MARK: - Private

    private let searchResult: SearchResult
    private var cancellables = Set<AnyCancellable>()
}
