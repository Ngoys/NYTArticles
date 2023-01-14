import Foundation

struct DocumentArticle: Codable, Hashable {
    let id: String?
    let headline: Headline?
    let publishedDate: Date?

    //----------------------------------------
    // MARK: - Coding keys
    //----------------------------------------

    enum CodingKeys: String, CodingKey {
        case id
        case headline
        case publishedDate = "pub_date"
    }
}
