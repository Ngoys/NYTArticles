import Foundation
import Combine

class ArticleStore: BaseStore {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func fetchArticles(articleListingContentType: ArticleListingContentType) -> AnyPublisher<[Article], Error> {
        var endPoint = ""

        switch articleListingContentType {
        case .mostEmailed:
            endPoint = "mostpopular/v2/emailed/1.json"

        case .mostShared:
            endPoint = "mostpopular/v2/shared/1/facebook.json"

        case .mostViewed:
            endPoint = "mostpopular/v2/viewed/7.json"
        }

        let publisher = apiClient.apiRequest(.get, endPoint, requiresAuthorization: true)
            .tryMap { apiResponse -> [Article] in
                let decodedModel = try self.decoder.decode([Article].self, from: apiResponse.data)
                return decodedModel
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        return publisher
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let apiClient: APIClient
}
