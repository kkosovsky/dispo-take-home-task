import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var container: DependencyContainerType = DependencyContainer()
    var assembly: Assembly?
    private lazy var router: Routing = Router(
        navigationController: UINavigationController(),
        controllerFactory: container.resolve(type: ControllerFactoryType.self),
        navigationActionConfigurator: container.resolve(type: NavigationActionConfiguratorType.self)
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        assembly = ApplicationAssembly(container: container)
        assembly?.assemble()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = router.navigationController
        self.window = window
        window.makeKeyAndVisible()

        router.go(to: .search)
    }
}
