import UIKit

protocol ControllerFactoryType {
    func makeController(for route: Route) -> UIViewController
}
