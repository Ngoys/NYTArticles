import Foundation
import Combine

class HomeViewModel {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var homeMenuSections: [HomeMenuSection] {
        let searchSection = HomeMenuSection(type: .search, menus: [.searchArticle])
        let popularSection = HomeMenuSection(type: .popular, menus: [.mostViewed, .mostShared, .mostEmailed])

        let homeMenuSections = [searchSection, popularSection]
        return homeMenuSections
    }
}
