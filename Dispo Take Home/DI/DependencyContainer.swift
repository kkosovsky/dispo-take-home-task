import Foundation

final class DependencyContainer: DependencyContainerType {

    func register<Service>(type: Service.Type, factory: @escaping (DependencyResolver) -> Any) {
        services["\(type)"] = factory
    }

    func register<Service, Arg>(type: Service.Type, factory: @escaping (DependencyResolver, Arg) -> Any) {
        let entry = ServiceEntry(serviceType: type, argumentsType: Arg.self, factory: factory)
        servicesWithArgs["\(type)"] = entry
    }

    func resolve<Service>(type: Service.Type) -> Service {
        services["\(type)"]?(self) as! Service
    }

    func resolve<Service, Arg>(type: Service.Type, arg: Arg) -> Service {
        let entry = servicesWithArgs["\(type)"]!
        let typedFactory = entry.factory as! (DependencyResolver, Arg) -> Any
        return typedFactory(self, arg) as! Service
    }

    private var services = Dictionary<String, (DependencyResolver) -> Any>()
    private var servicesWithArgs = Dictionary<String, ServiceEntryType>()
}
