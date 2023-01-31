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

    func testTitleText() {
        setupViewModel(homeMenu: .mostEmailed)
        XCTAssertEqual(viewModel.titleText, "Most Emailed")

        setupViewModel(homeMenu: .mostShared)
        XCTAssertEqual(viewModel.titleText, "Most Shared")

        setupViewModel(homeMenu: .mostViewed)
        XCTAssertEqual(viewModel.titleText, "Most Viewed")

        setupViewModel(homeMenu: .searchArticle)
        XCTAssertEqual(viewModel.titleText, "Search Articles")

        let mockCLLocation = CLLocation(latitude: 10, longitude: -10)
        setupViewModel(homeMenu: .location(clLocation: mockCLLocation))

        XCTAssertEqual(viewModel.titleText, "Latitude: \(mockCLLocation.coordinate.latitude)\nLongitude: \(mockCLLocation.coordinate.longitude)")
    }

    func testIsRightArrowImageViewHidden() {
        setupViewModel(homeMenu: .mostEmailed)
        XCTAssertEqual(viewModel.isRightArrowImageViewHidden, false)

        setupViewModel(homeMenu: .mostShared)
        XCTAssertEqual(viewModel.isRightArrowImageViewHidden, false)

        setupViewModel(homeMenu: .mostViewed)
        XCTAssertEqual(viewModel.isRightArrowImageViewHidden, false)

        setupViewModel(homeMenu: .searchArticle)
        XCTAssertEqual(viewModel.isRightArrowImageViewHidden, false)

        let mockCLLocation = CLLocation(latitude: 10, longitude: -10)
        setupViewModel(homeMenu: .location(clLocation: mockCLLocation))
        XCTAssertEqual(viewModel.isRightArrowImageViewHidden, true)
    }
}
