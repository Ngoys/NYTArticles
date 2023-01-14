import Foundation

struct Article: Codable, Hashable {
    let id: Int
    let title: String?
    let publishedDate: Date?

    //----------------------------------------
    // MARK: - Coding keys
    //----------------------------------------

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedDate = "published_date"
    }

    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}
