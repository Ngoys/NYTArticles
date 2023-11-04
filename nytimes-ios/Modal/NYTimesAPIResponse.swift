import Foundation

struct NYTimesAPIResponse<T: Decodable>: Decodable {
    let status: String
    let copyright: String
    let response: T
}
