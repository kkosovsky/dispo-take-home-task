import Combine

protocol NavigationActionProducer {
    var action: AnyPublisher<NavigationAction, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}
