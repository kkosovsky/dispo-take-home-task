import Foundation

final class ApplicationAssembly: Assembly {

    // MARK: Initialization

    init(container: DependencyContainerType) {
        self.container = container
    }

    // MARK: - Assembly

    func assemble() {
        assemble(container: container)
    }

    // MARK: - Private

    private let container: DependencyContainerType

    private func assemble(container: DependencyContainerType) {
        container.register(type: ControllerFactoryType.self) { resolver in
            ControllerFactory(resolver: resolver)
        }

        container.register(type: NavigationActionConfiguratorType.self) { _ in
            NavigationActionConfigurator()
        }

        container.register(type: MainViewController.self) { _ in
            MainViewController()
        }

        container.register(type: DetailViewController.self) { _, gifId in
            DetailViewController(gifId: gifId)
        }
    }
}
