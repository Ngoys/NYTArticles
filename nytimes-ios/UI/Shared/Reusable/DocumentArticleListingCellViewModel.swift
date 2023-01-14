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
        return self.documentArticle.headline?.printHeadline
    }

    var dateText: String? {
        return NYTimesDateFormatter.relativeDateFormatter(fromDate: self.documentArticle.publishedDate, doesRelativeDateFormatting: true)
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let documentArticle: DocumentArticle
}
