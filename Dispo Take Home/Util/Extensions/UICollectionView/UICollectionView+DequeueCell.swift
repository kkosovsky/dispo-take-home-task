import UIKit

extension UICollectionView {
    public func dequeueCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with reuse identifier: \(cellType.reuseIdentifier)")
        }

        return cell
    }
}
