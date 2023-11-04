import Foundation

struct NYTimesAPIResult<T: Decodable>: Decodable {
    let status: String
    let copyright: String
    let numResults: Int?
    let results: T

    //----------------------------------------
    // MARK: - Coding keys
    //----------------------------------------

    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numResults = "num_results"
        case results
    }
}
