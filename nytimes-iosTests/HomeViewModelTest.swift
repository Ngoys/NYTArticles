import XCTest
import Cuckoo
import Combine
import CoreLocation
@testable import nytimes_ios

class HomeViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: HomeViewModel!

    var mockCLLocationManager: MockCLLocationManager!

    let mockCLLocations = [
        CLLocation(latitude: 30, longitude: -30),
    ]

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel() {
        viewModel = HomeViewModel(locationManager: mockCLLocationManager)
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testHomeContent() {
        mockCLLocationManager = MockCLLocationManager(clLocations: [])
        setupViewModel()

        XCTAssertEqual(viewModel.homeMenuSections.count, 2)
        XCTAssertEqual(viewModel.homeMenuSections[0].menus.count, 1)
        XCTAssertEqual(viewModel.homeMenuSections[1].menus.count, 3)
    }

    func testHomeContentWithCLLocation() {
        mockCLLocationManager = MockCLLocationManager(clLocations: mockCLLocations)
        setupViewModel()

        XCTAssertEqual(viewModel.homeMenuSections.count, 3)
        XCTAssertEqual(viewModel.homeMenuSections[0].menus.count, 1)
        XCTAssertEqual(viewModel.homeMenuSections[1].menus.count, 3)
        XCTAssertEqual(viewModel.homeMenuSections[2].menus.count, 1)

        if let section = viewModel.homeMenuSections.first(where: { $0.type == .location }) {
            switch section.menus.first {
            case .location(let clLocation):
                XCTAssertEqual(clLocation.coordinate.latitude, mockCLLocations.first!.coordinate.latitude)
                XCTAssertEqual(clLocation.coordinate.longitude, mockCLLocations.first!.coordinate.longitude)

            default:
                XCTFail("Should not execute this block clause")
            }
        } else {
            XCTFail("Should not execute this block clause")
        }
    }
}
