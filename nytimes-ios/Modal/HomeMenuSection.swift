import Foundation
import CoreLocation

struct HomeMenuSection: Hashable {
    let type: HomeMenuSectionType
    let menus: [HomeMenu]

    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }

    static func == (lhs: HomeMenuSection, rhs: HomeMenuSection) -> Bool {
        lhs.type == rhs.type
    }
}

enum HomeMenuSectionType: Int, Hashable {
    case search
    case popular
    case location

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var name: String {
        switch self {
        case .search:
            return R.string.localizable.search()

        case .popular:
            return R.string.localizable.popular()

        case .location:
            return R.string.localizable.location()
        }
    }
}

enum HomeMenu: Hashable {
    case searchArticle
    case mostViewed
    case mostShared
    case mostEmailed
    case location(clLocation: CLLocation)

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var name: String {
        switch self {
        case .searchArticle:
            return R.string.localizable.search_articles()

        case .mostViewed:
            return R.string.localizable.most_viewed()

        case .mostShared:
            return R.string.localizable.most_shared()

        case .mostEmailed:
            return R.string.localizable.most_emailed()

        case .location:
            return R.string.localizable.location()
        }
    }

    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------

    static func == (lhs: HomeMenu, rhs: HomeMenu) -> Bool {
        return false
    }
}
