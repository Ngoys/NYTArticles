import Foundation
import CoreLocation

class MockCLLocationManager: CLLocationManager {

    init(clLocations: [CLLocation]) {
        self.clLocations = clLocations
        super.init()
    }

    override func startUpdatingLocation() {
        // https://stackoverflow.com/a/45907868/18209126
        self.delegate?.locationManager?(self, didUpdateLocations: clLocations)
    }

    private let clLocations: [CLLocation]
}
