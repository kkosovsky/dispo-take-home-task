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

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let output = (searchResult.id |> TenorAPIClient.live.gifInfo)
        output.sink { gifInfo in
            print(gifInfo)
        }.store(in: &cancellables)
    }

    // MARK: - Private

    private let searchResult: SearchResult
    private var cancellables = Set<AnyCancellable>()
}
