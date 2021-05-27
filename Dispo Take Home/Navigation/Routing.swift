import UIKit

protocol Routing: AnyObject {
    var navigationController: UINavigationController { get }

    func go(to route: Route)
    func goBack()
}
