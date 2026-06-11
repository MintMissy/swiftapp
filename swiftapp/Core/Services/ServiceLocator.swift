import Foundation

class ServiceLocator {
    static let shared = ServiceLocator()
    
    private var services: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(_ service: T) {
        let key = String(describing: type(of: T.self))
        services[key] = service
    }
    
    func resolve<T>() -> T {
        let key = String(describing: type(of: T.self))
        guard let service = services[key] as? T else {
            fatalError("Failed to resolve dependency \(T.self)")
        }
        return service
    }
}
