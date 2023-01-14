import UIKit

protocol HomeCoordinatorDelegate: NSObjectProtocol {
}

class HomeCoordinator: BaseCoordinator {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    init(homeViewController: HomeViewController) {
        homeViewController.viewModel = HomeViewModel()

        self.homeViewController = homeViewController
    }

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: HomeCoordinatorDelegate?

    //----------------------------------------
    // MARK:- Starting flows
    //----------------------------------------

    func start() {
        self.homeViewController.delegate = self
        _ = showSearch(activeViewController: homeViewController) //shawn DO NOT KEEP
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let homeViewController: HomeViewController
}

//----------------------------------------
// MARK:- HomeViewController delegate
//----------------------------------------

extension HomeCoordinator: HomeViewControllerDelegate {

    func homeViewControllerDidSelectSearchArticle(_ homeViewController: HomeViewController) {
        _ = showSearch(activeViewController: homeViewController)
    }

    func homeViewControllerDidSelectMostViewed(_ homeViewController: HomeViewController) {
        _ = showArticleListing(activeViewController: homeViewController, articleListingContentType: .mostViewed)
    }

    func homeViewControllerDidSelectMostShared(_ homeViewController: HomeViewController) {
        _ = showArticleListing(activeViewController: homeViewController, articleListingContentType: .mostShared)
    }

    func homeViewControllerDidSelectMostEmailed(_ homeViewController: HomeViewController) {
        _ = showArticleListing(activeViewController: homeViewController, articleListingContentType: .mostEmailed)
    }
}
