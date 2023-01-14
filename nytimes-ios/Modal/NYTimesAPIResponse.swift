import Foundation

struct NYTimesAPIResponse<T>: Decodable where T: Decodable {
    let status: String
    let copyright: String
    let response: T

    //----------------------------------------
    // MARK: - Coding keys
    //----------------------------------------

    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case response
    }
}
