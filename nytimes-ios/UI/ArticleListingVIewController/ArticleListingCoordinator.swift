import UIKit

protocol ArticleListingCoordinatorDelegate: NSObjectProtocol {
}

class ArticleListingCoordinator: BaseCoordinator {
    
    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    init(activeViewController: UIViewController) {
        self.activeViewController = activeViewController

        let (_, articleListingViewController) = ArticleListingViewController.fromStoryboard()
        articleListingViewController.viewModel = ArticleListingViewModel()
        self.articleListingViewController = articleListingViewController
    }

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: ArticleListingCoordinatorDelegate?

    //----------------------------------------
    // MARK:- Starting flows
    //----------------------------------------

    func start() {
        self.articleListingViewController.delegate = self

        self.activeViewController.navigationController?.pushViewController(self.articleListingViewController, animated: true)
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let activeViewController: UIViewController

    private let articleListingViewController: ArticleListingViewController
}

//----------------------------------------
// MARK:- ArticleListingViewController delegate
//----------------------------------------

extension ArticleListingCoordinator: ArticleListingViewControllerDelegate {
}
