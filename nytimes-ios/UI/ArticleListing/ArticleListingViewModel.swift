import Foundation
import Combine

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
        print("ArticleListingViewModel - fetchArticles(\(articleListingContentType.name))")
        return articleStore.fetchArticles(articleListingContentType: articleListingContentType)
            .map { articles in
                articles.forEach { article in
                    self.articleStore.createOrUpdateArticleDataModal(article: article, articleListingContentType: self.articleListingContentType)
                }
                return articles
            }.eraseToAnyPublisher()
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func fetchCoreDataArticles() -> [Article] {
        print("ArticleListingViewModel - fetchCoreDataArticles(\(articleListingContentType.name))")
        return articleStore.fetchCoreDataArticles(articleListingContentType: articleListingContentType)
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let articleListingContentType: ArticleListingContentType

    private let articleStore: ArticleStore
}
