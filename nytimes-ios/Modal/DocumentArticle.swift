import Foundation

struct DocumentArticle: Codable, Hashable {
    let id: String?
    let abstract: String?
    let publishedDate: Date?

    //----------------------------------------
    // MARK: - Coding keys
    //----------------------------------------

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case abstract
        case publishedDate = "pub_date"
    }

    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DocumentArticle, rhs: DocumentArticle) -> Bool {
        lhs.id == rhs.id
    }
}
