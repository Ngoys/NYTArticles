import Foundation

public enum AppError: Error, Equatable {
    case invalidData
    case urlError
    case network
    
    // HTTP Status Code 400 range.
    case authentication
    case badRequest
    case notFound
    case invalidateSession
    
    case emptySearchResult
    
    // HTTP Status code 500 range.
    case serverError
}
