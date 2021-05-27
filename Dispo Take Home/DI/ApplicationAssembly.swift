import Foundation

final class ApplicationAssembly: Assembly {

    init(container: DependencyContainerType) {
        self.container = container
    }

    func assemble() {
        assemble(container: container)
    }

    private let container: DependencyContainerType

    private func assemble(container: DependencyContainerType) {
        container.register(type: ControllerFactoryType.self) { resolver in
            ControllerFactory(resolver: resolver)
        }

        container.register(type: MainViewController.self) { _ in
            MainViewController()
        }

        container.register(type: DetailViewController.self) { _, gifId in
            DetailViewController(gifId: gifId)
        }
    }
}
