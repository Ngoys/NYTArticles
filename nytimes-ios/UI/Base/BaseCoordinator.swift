import UIKit
import Combine

class BaseCoordinator: NSObject {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func showArticleListing(activeViewController: UIViewController) {
        let articleListingCoordinator = ArticleListingCoordinator(activeViewController: activeViewController)
        articleListingCoordinator.start()
    }
}
