import Foundation

struct Article: Codable, Hashable {
    let id: String
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

    //----------------------------------------
    // MARK: - Decodable protocols
    //----------------------------------------

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try String(container.decode(Int.self, forKey: .id))
        title = try container.decodeIfPresent(String.self, forKey: .title)
        publishedDate = try container.decodeIfPresent(Date.self, forKey: .publishedDate)
    }

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(id: String, title: String? = nil, publishedDate: Date? = nil) {
        self.id = id
        self.title = title
        self.publishedDate = publishedDate
    }
}
