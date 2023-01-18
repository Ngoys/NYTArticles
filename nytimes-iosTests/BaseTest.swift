import XCTest
import Cuckoo
import Combine
@testable import nytimes_ios

class BaseTest: XCTestCase {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var mockAPIClient: MockNYTimesAPIClient!

    var mockHTTPClient: MockHTTPClient!

    var mockCoreDataStack: MockCoreDataStack!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    override func setUp() {
        mockCoreDataStack = MockCoreDataStack()

        mockHTTPClient = MockHTTPClient()
        mockAPIClient = MockNYTimesAPIClient(apiBaseURL: apiBaseURL, httpClient: mockHTTPClient)
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    let apiBaseURL = AppConstant.baseURL

    var cancellables: Set<AnyCancellable> = Set()
}
