import Foundation

protocol DependencyContainerType: DependencyResolver {
    func register<Service>(type: Service.Type, factory: @escaping (DependencyResolver) -> Any)
    func register<Service, Arg>(type: Service.Type, factory: @escaping (DependencyResolver, Arg) -> Any)
}

protocol DependencyResolver {
    func resolve<Service>(type: Service.Type) -> Service
    func resolve<Service, Argument>(type: Service.Type, arg: Argument) -> Service
}
