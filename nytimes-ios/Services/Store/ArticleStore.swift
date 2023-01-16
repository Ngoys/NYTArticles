import Foundation
import Combine

class ArticleStore: BaseStore {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(apiClient: APIClient, coreDataProvider: CoreDataProvider) {
        self.apiClient = apiClient
        self.coreDataProvider = coreDataProvider
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
                let decodedModel = try self.decoder.decode(NYTimesAPIResult<[Article]>.self, from: apiResponse.data)
                return decodedModel.results
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        return publisher
    }

    func searchDocumentArticles(keyword: String, pageNumber: Int = 1) -> AnyPublisher<[DocumentArticle], Error> {
        let endPoint = "search/v2/articlesearch.json"

        let queryItems = [
            URLQueryItem(name: "q", value: keyword.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")),
            URLQueryItem(name: "page", value: "\(pageNumber)")
        ]

        let publisher = apiClient.apiRequest(.get, endPoint, queryItems: queryItems, requiresAuthorization: true)
            .tryMap { apiResponse -> [DocumentArticle] in
                let decodedModel = try self.decoder.decode(NYTimesAPIResponse<SearchResponse>.self, from: apiResponse.data)
                return decodedModel.response.docs
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        return publisher
    }

    func createOrUpdateArticleDataModal(article: Article, articleListingContentType: ArticleListingContentType) {
        coreDataProvider.createOrUpdateArticle(article: article, articleListingContentType: articleListingContentType)
    }

    func fetchCoreDataArticles(articleListingContentType: ArticleListingContentType) -> [Article] {
        return coreDataProvider.fetchArticles(articleListingContentType: articleListingContentType)
    }

    func deleteAllCoreDataArticles() {
        return coreDataProvider.deleteAllArticles()
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let apiClient: APIClient

    private let coreDataProvider: CoreDataProvider
}
