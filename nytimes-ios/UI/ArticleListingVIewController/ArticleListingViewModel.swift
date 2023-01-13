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

    init(articleListingContentType: ArticleListingContentType) {
        self.articleListingContentType = articleListingContentType
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let articleListingContentType: ArticleListingContentType
}
