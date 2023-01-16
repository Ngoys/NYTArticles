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
        container = ServiceContainer.registerCoreData(inContainer: container)
        return container
    }()

    //----------------------------------------
    // MARK: - Services
    //----------------------------------------

    private static func registerStores(inContainer container: Container) -> Container {
        container.register(HTTPClient.self) { r -> HTTPClient in
            return HTTPClient()
        }.inObjectScope(.container)

        container.register(NYTimesAPIClient.self) { r -> NYTimesAPIClient in
            let httpClient = r.resolve(HTTPClient.self)!
            return NYTimesAPIClient(apiBaseURL: AppConstant.baseURL, httpClient: httpClient)
        }.inObjectScope(.container)

        container.register(ArticleStore.self) { r -> ArticleStore in
            let nyTimesAPIClient = r.resolve(NYTimesAPIClient.self)!
            let coreDataStore = r.resolve(CoreDataStore.self)!
            return ArticleStore(apiClient: nyTimesAPIClient, coreDataStore: coreDataStore)
        }.inObjectScope(.container)

        return container
    }

    private static func registerCoreData(inContainer container: Container) -> Container {
        container.register(CoreDataStack.self) { r -> CoreDataStack in
            return CoreDataStack()
        }.inObjectScope(.container)

        container.register(CoreDataStore.self) { r -> CoreDataStore in
            let coreDataStack = r.resolve(CoreDataStack.self)!
            return CoreDataStore(coreDataStack: coreDataStack)
        }.inObjectScope(.container)

        return container
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private static let userDefaults = UserDefaults.standard
}
