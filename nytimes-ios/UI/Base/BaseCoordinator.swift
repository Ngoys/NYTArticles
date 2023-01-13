import UIKit
import Combine

class BaseCoordinator: NSObject {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func showArticleListing(activeViewController: UIViewController, articleListingContentType: ArticleListingContentType) {
        let articleListingCoordinator = ArticleListingCoordinator(activeViewController: activeViewController, articleListingContentType: articleListingContentType)
        articleListingCoordinator.start()
    }
}
