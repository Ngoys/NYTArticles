import Foundation

struct HomeMenuSection: Hashable {
    let type: HomeMenuSectionType
    let menus: [HomeMenuType]

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

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var name: String {
        switch self {
        case .search:
            return R.string.localizable.search()

        case .popular:
            return R.string.localizable.popular()
        }
    }
}

enum HomeMenuType: Hashable {
    case searchArticle
    case mostViewed
    case mostShared
    case mostEmailed

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
        }
    }

    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------

    static func == (lhs: HomeMenuType, rhs: HomeMenuType) -> Bool {
        return false
    }
}
