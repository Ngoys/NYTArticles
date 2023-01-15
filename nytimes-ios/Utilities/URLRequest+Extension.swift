import Foundation

extension URLRequest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}
