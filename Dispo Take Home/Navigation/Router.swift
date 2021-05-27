import UIKit

final class Router: Routing {

    // MARK: - Initialization

    public init(
        navigationController: UINavigationController,
        controllerFactory: ControllerFactoryType,
        navigationActionConfigurator: NavigationActionConfiguratorType
    ) {
        self.navigationController = navigationController
        self.controllerFactory = controllerFactory
        self.navigationActionConfigurator = navigationActionConfigurator
    }

    // MARK: - Routing

    private(set) var navigationController: UINavigationController

    func go(to route: Route) {
        go(to: route, onStack: navigationController.viewControllers)
    }

    func goBack() {
        let stack = navigationController.viewControllers
        if stack.count > 1 {
            navigationController.popViewController(animated: true)
        }
    }

    // MARK: - Private

    private let controllerFactory: ControllerFactoryType
    private let navigationActionConfigurator: NavigationActionConfiguratorType

    private func go(to route: Route, onStack stack: [UIViewController]) {
        let controller = configuredController(for: route)
        navigationController.setViewControllers(stack.appending(controller), animated: true)
    }

    private func configuredController(for route: Route) -> UIViewController {
        let controller = controllerFactory.makeController(for: route)
        navigationActionConfigurator.configure(controller: controller, with: self)
        return controller
    }
}
