import Combine
import UIKit

protocol NavigationActionConfiguratorType {
    func configure(controller: UIViewController, with router: Routing)
}
