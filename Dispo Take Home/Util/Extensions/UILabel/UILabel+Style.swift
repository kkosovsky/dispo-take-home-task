import UIKit

extension UILabel {
    static func aligned(_ alignment: NSTextAlignment) -> (UILabel) -> Void {
        {
            $0.textAlignment = alignment
        }
    }

    static func withText(_ text: String) -> (UILabel) -> Void {
        {
            $0.text = text
        }
    }
}
