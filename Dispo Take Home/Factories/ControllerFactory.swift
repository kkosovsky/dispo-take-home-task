import UIKit

final class ControllerFactory: ControllerFactoryType {

    // MARK: - Initialization

    init(resolver: DependencyResolver) {
        self.resolver = resolver
    }

    // MARK: - ControllerFactoryType

    func makeController(for route: Route) -> UIViewController {
        switch route {
        case .search:
            return resolver.resolve(type: MainViewController.self)
        case let .details(gifId):
            return resolver.resolve(type: DetailViewController.self, arg: gifId)
        }
    }

    // MARK: - Private

    private let resolver: DependencyResolver
}
