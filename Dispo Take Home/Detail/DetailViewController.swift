import Combine
import UIKit

class DetailViewController: UIViewController {

    // MARK: - Initialization

    init(searchResult: SearchResult) {
        self.searchResult = searchResult
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    private lazy var detailView = DetailView()

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let output = (searchResult.id |> TenorAPIClient.live.gifInfo)
        output.sink { [weak self] gifInfo in
            self?.detailView.gifImageView.kf.setImage(with: gifInfo.gifUrl)
            self?.detailView.titleLabel.text = gifInfo.title
            self?.detailView.sharesLabel.text = "\(gifInfo.shares) shares"
            self?.detailView.tagsLabel.text = gifInfo.tags.reduce(into: "", {$0 + ", " + $1})
        }.store(in: &cancellables)
    }

    // MARK: - Private

    private let searchResult: SearchResult
    private var cancellables = Set<AnyCancellable>()
}
