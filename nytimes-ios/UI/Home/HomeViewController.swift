import UIKit

protocol HomeViewControllerDelegate: NSObjectProtocol {
}

class HomeViewController: BaseViewController {

    class func fromStoryboard() -> (UINavigationController, HomeViewController) {
        let navigationController = R.storyboard.home().instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! HomeViewController)
    }

    //----------------------------------------
    // MARK:- View model
    //----------------------------------------

    var viewModel: HomeViewModel!

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: HomeViewControllerDelegate?

    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------

    override func configureViews() {

    }

    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------

    override func bindViewModel() {

    }
}
