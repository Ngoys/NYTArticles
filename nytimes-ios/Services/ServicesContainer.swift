import Foundation
import Swinject

// swiftlint:disable all
class ServiceContainer {
    
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    static let container: Container = {
        var container: Container = Container()
        container = ServiceContainer.registerStores(inContainer: container)
        return container
    }()

    //----------------------------------------
    // MARK: - Services
    //----------------------------------------

    private static func registerStores(inContainer container: Container) -> Container {
        return container
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private static let userDefaults = UserDefaults.standard
}
