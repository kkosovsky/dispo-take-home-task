import SnapKit
import UIKit

final class MainView: UIView {

    private var layout: UICollectionViewLayout {
        // TODO: implement
        UICollectionViewLayout()
    }

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()

    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search gifs..."
        return searchBar
    }()

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        addSubviews()
        setUpLayout()
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Private

    private func addSubviews() {
        addSubview(collectionView)
    }

    private func setUpLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
