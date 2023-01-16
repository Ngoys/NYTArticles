import UIKit

enum ArticleListingContentType {
    case mostViewed 
    case mostShared
    case mostEmailed

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var name: String {
        switch self {
        case .mostViewed:
            return "most_viewed"

        case .mostShared:
            return "most_shared"

        case .mostEmailed:
            return "most_emailed"
        }
    }
}
