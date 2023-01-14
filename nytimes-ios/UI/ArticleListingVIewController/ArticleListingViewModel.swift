import Foundation
import Combine

enum ArticleListingContentType {
    case mostViewed
    case mostShared
    case mostEmailed
}

class ArticleListingViewModel {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    init(articleListingContentType: ArticleListingContentType, articleStore: ArticleStore) {
        self.articleListingContentType = articleListingContentType
        self.articleStore = articleStore
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let articleListingContentType: ArticleListingContentType

    private let articleStore: ArticleStore
}
