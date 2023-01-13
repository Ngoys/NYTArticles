import Foundation
import UIKit

class HomeMenuCellViewModel {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(homeMenu: HomeMenu) {
        self.homeMenu = homeMenu
    }
    
    //----------------------------------------
    // MARK: - Presentation
    //----------------------------------------

    var titleText: String? {
        return self.homeMenu.name
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let homeMenu: HomeMenu
}
