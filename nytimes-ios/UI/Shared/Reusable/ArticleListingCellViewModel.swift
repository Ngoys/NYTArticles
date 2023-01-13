import Foundation
import UIKit

class ArticleListingCellViewModel {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(article: Article) {
        self.article = article
    }
    
    //----------------------------------------
    // MARK: - Presentation
    //----------------------------------------

    var titleText: String? {
        return self.article.title
    }

    var dateText: String? {
        // TODO
        return self.article.title
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let article: Article
}
