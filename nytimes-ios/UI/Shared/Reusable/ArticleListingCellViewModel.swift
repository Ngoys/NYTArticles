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
        return NYTimesDateFormatter.relativeDateFormatter(fromDate: self.article.publishedDate, doesRelativeDateFormatting: true) 
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let article: Article
}
