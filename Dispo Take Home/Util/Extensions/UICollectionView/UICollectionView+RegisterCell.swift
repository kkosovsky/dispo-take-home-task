import UIKit

extension UICollectionView {
    public func registerCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}
