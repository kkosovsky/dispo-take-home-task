import UIKit

extension Reusable where Self: UIView {

    public static var reuseIdentifier: String {
        String(describing: self)
    }
}
