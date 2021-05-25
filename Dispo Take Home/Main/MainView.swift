import SnapKit
import UIKit

final class MainView: UIView {

    private var layout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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
        backgroundColor = .white
        addSubview(collectionView)
        setUpLayout()
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Private

    private func setUpLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
