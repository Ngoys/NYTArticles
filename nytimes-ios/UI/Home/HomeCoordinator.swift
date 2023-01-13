import UIKit

protocol HomeCoordinatorDelegate: NSObjectProtocol {
}

class HomeCoordinator: NSObject {
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
    }


    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let homeViewController: HomeViewController
}

//----------------------------------------
// MARK:- Home view controller delegate
//----------------------------------------

extension HomeCoordinator: HomeViewControllerDelegate {
}
