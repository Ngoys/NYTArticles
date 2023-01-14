import Combine
import Foundation

class NYTimesAPIClient: APIClient {
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(apiBaseURL: URL, httpClient: HTTPClient) {
        self._apiBaseURL = apiBaseURL
        self.httpClient = httpClient
    }
    
    //----------------------------------------
    // MARK: - APIClient Protocol
    //----------------------------------------
    
    var apiBaseURL: URL {
        return self._apiBaseURL
    }
    
    func apiRequest(
        _ method: URLRequest.HTTPMethod,
        _ path: String,
        queryItems: [URLQueryItem]? = nil,
        requestHeader: [String: String]? = nil,
        requestBody: Data? = nil,
        requiresAuthorization: Bool = false) -> AnyPublisher<APIResponse, Error>  {
            var apiURL: URL?
            let url = apiBaseURL.appendingPathComponent(path)

            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return Fail(error: AppError.urlError).eraseToAnyPublisher()
            }
            
            // Append query items.
            urlComponents.queryItems = queryItems
            apiURL = urlComponents.url
            
            guard let url = apiURL else {
                return Fail(error: AppError.urlError).eraseToAnyPublisher()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            if let requestHeader = requestHeader {
                for (key, value) in requestHeader {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            request.httpBody = requestBody
            
            if requiresAuthorization {
                urlComponents.queryItems?.append(URLQueryItem(name: "api-key", value: AppConstant.apiKey))
            }

            return httpClient.apiRequest(request: request)
                .map { _, data -> APIResponse in
                    let apiResponse = NYTimesAPIResponse(data: data)
                    return apiResponse
                }.eraseToAnyPublisher()
        }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let _apiBaseURL: URL
    
    private let httpClient: HTTPClient
    
    private var cancellables: Set<AnyCancellable> = Set()
}
