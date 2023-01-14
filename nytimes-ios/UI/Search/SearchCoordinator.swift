import UIKit

protocol SearchCoordinatorDelegate: NSObjectProtocol {
}

class SearchCoordinator: BaseCoordinator {
    
    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    init(activeViewController: UIViewController) {
        self.activeViewController = activeViewController

        let (_, searchViewController) = SearchViewController.fromStoryboard()
        searchViewController.viewModel = SearchViewModel(
            articleStore: ServiceContainer.container.resolve(ArticleStore.self)!
        )
        self.searchViewController = searchViewController
    }

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: SearchCoordinatorDelegate?

    //----------------------------------------
    // MARK:- Starting flows
    //----------------------------------------

    func start() {
        self.searchViewController.delegate = self

        self.activeViewController.navigationController?.pushViewController(self.searchViewController, animated: true)
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let activeViewController: UIViewController

    private let searchViewController: SearchViewController
}

//----------------------------------------
// MARK:- SearchViewController delegate
//----------------------------------------

extension SearchCoordinator: SearchViewControllerDelegate {
}
