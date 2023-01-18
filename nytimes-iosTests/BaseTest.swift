import XCTest
import Cuckoo
import Combine
@testable import nytimes_ios

class BaseTest: XCTestCase {

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    var cancellables: Set<AnyCancellable> = Set()
}
