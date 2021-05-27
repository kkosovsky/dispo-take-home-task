import Combine
import UIKit

final class NavigationActionConfigurator: NavigationActionConfiguratorType {

    // MARK: - NavigationActionConfiguratorType

    func configure(controller: UIViewController, with router: Routing) {
        guard var navigationActionProducer = controller as? NavigationActionProducer else { return }
        navigationActionProducer.action.sink { [weak router] action in
            switch action {
            case let .goTo(route):
                router?.go(to: route)
            case .goBack:
                router?.goBack()
            }
        }.store(in: &navigationActionProducer.cancellables)
    }
}
