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
        switch self.homeMenu {
        case .location(let clLocation):
            return "\(R.string.localizable.latitude()): \(clLocation.coordinate.latitude)\n\(R.string.localizable.longitude()): \(clLocation.coordinate.longitude)"

        default:
            return self.homeMenu.name
        }
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let homeMenu: HomeMenu
}
