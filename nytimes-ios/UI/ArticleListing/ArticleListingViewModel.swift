import Foundation
import Combine

enum ArticleListingContentType {
    case mostViewed
    case mostShared
    case mostEmailed
}

class ArticleListingViewModel: StatefulViewModel<[Article]> {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    init(articleListingContentType: ArticleListingContentType, articleStore: ArticleStore) {
        self.articleListingContentType = articleListingContentType
        self.articleStore = articleStore
    }

    //----------------------------------------
    // MARK: - Data loading
    //----------------------------------------

    override func load() -> AnyPublisher<[Article], Error> {
        return articleStore.fetchArticles(articleListingContentType: articleListingContentType)
            .map { articles in
                self.articleStore.createOrUpdateArticles(articles: articles)
                return articles
            }.eraseToAnyPublisher()
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let articleListingContentType: ArticleListingContentType

    private let articleStore: ArticleStore
}
