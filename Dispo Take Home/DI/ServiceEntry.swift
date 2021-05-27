protocol ServiceEntryType: AnyObject {
    var factory: Any { get }
    var serviceType: Any.Type { get }
}

class ServiceEntry<Service>: ServiceEntryType {
    var serviceType: Any.Type
    var factory: Any
    private let argumentsType: Any.Type

    init(serviceType: Service.Type, argumentsType: Any.Type, factory: Any) {
        self.serviceType = serviceType
        self.factory = factory
        self.argumentsType = argumentsType
    }
}
