import XCTest
import Cuckoo
import Combine
import CoreLocation
@testable import nytimes_ios

class HomeMenuCellViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: HomeMenuCellViewModel!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel(homeMenu: HomeMenu) {
        viewModel = HomeMenuCellViewModel(homeMenu: homeMenu)
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testMostEmailedHomeMenuTitleText() {
        setupViewModel(homeMenu: .mostEmailed)
        XCTAssertEqual(viewModel.titleText, "Most Emailed")
    }

    func testMostSharedHomeMenuTitleText() {
        setupViewModel(homeMenu: .mostShared)
        XCTAssertEqual(viewModel.titleText, "Most Shared")
    }

    func testMostViewedHomeMenuTitleText() {
        setupViewModel(homeMenu: .mostViewed)
        XCTAssertEqual(viewModel.titleText, "Most Viewed")
    }

    func testSearchArticleHomeMenuTitleText() {
        setupViewModel(homeMenu: .searchArticle)
        XCTAssertEqual(viewModel.titleText, "Search Articles")
    }

    func testLocationHomeMenuTitleText() {
        let mockCLLocation = CLLocation(latitude: 10, longitude: -10)
        setupViewModel(homeMenu: .location(clLocation: mockCLLocation))
        
        XCTAssertEqual(viewModel.titleText, "Latitude: \(mockCLLocation.coordinate.latitude)\nLongitude: \(mockCLLocation.coordinate.longitude)")
    }
}
