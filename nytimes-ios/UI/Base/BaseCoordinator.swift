import UIKit
import Combine

class BaseCoordinator: NSObject {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func showArticleListing(activeViewController: UIViewController, articleListingContentType: ArticleListingContentType) -> ArticleListingCoordinator {
        let articleListingCoordinator = ArticleListingCoordinator(activeViewController: activeViewController, articleListingContentType: articleListingContentType)
        articleListingCoordinator.start()
        return articleListingCoordinator
    }

    func showSearch(activeViewController: UIViewController) -> SearchCoordinator {
        let searchCoordinator = SearchCoordinator(activeViewController: activeViewController)
        searchCoordinator.start()
        return searchCoordinator
    }
}
