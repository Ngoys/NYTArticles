import Foundation
import UIKit

class DocumentArticleListingCellViewModel {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(documentArticle: DocumentArticle) {
        self.documentArticle = documentArticle
    }
    
    //----------------------------------------
    // MARK: - Presentation
    //----------------------------------------

    var titleText: String? {
        return self.documentArticle.abstract
    }

    var dateText: String? {
        return NYTimesDateFormatter.relativeDateFormatter(fromDate: self.documentArticle.publishedDate)
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let documentArticle: DocumentArticle
}
