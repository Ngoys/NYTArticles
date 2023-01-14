import Foundation

struct Headline: Codable, Hashable {
    let printHeadline: String?

    //----------------------------------------
    // MARK: - Coding keys
    //----------------------------------------

    enum CodingKeys: String, CodingKey {
        case printHeadline = "print_headline"
    }
}
