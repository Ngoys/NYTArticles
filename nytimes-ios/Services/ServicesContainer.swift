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
        container.register(HTTPClient.self) { r -> HTTPClient in
            return HTTPClient()
        }.inObjectScope(.container)

        container.register(NYTimesAPIClient.self) { r -> NYTimesAPIClient in
            let httpClient = r.resolve(HTTPClient.self)!
            return NYTimesAPIClient(apiBaseURL: AppConstant.baseURL, httpClient: httpClient)
        }.inObjectScope(.container)

        container.register(ArticleStore.self) { r -> ArticleStore in
            let nyTimesAPIClient = r.resolve(NYTimesAPIClient.self)!
            return ArticleStore(apiClient: nyTimesAPIClient)
        }.inObjectScope(.container)

        return container
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private static let userDefaults = UserDefaults.standard
}
