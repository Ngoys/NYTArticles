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

    let calendar = Calendar.current
    let today = Date()
    var midnight: Date!
    var tomorrow: Date!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    override func setUp() {
        midnight = calendar.startOfDay(for: today)
        tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!

        let coreDataStack = CoreDataStack()
        mockCoreDataStack = MockCoreDataStack()

        mockHTTPClient = MockHTTPClient()
        mockAPIClient = MockNYTimesAPIClient(apiBaseURL: apiBaseURL, httpClient: mockHTTPClient)

        Cuckoo.stub(mockCoreDataStack) { stub in
            when(stub.mainContext).get.thenReturn(coreDataStack.mainContext)
            when(stub.backgroundContext).get.thenReturn(coreDataStack.backgroundContext)
        }
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    let apiBaseURL = AppConstant.baseURL

    var cancellables: Set<AnyCancellable> = Set()
}
