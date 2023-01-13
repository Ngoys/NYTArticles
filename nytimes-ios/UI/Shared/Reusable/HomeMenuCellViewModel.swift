import Foundation
import UIKit

class HomeMenuCellViewModel {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(homeMenuType: HomeMenuType) {
        self.homeMenuType = homeMenuType
    }
    
    //----------------------------------------
    // MARK: - Presentation
    //----------------------------------------

    var titleText: String? {
        return self.homeMenuType.name
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let homeMenuType: HomeMenuType
}
