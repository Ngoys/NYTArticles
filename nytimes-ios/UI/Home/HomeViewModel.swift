import Foundation
import Combine
import CoreLocation

class HomeViewModel: BaseViewModel {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager

        super.init()

        let searchSection = HomeMenuSection(type: .search, menus: [.searchArticle])
        let popularSection = HomeMenuSection(type: .popular, menus: [.mostViewed, .mostShared, .mostEmailed])
        let homeMenuSections = [searchSection, popularSection]
        homeMenuSectionsSubject.send(homeMenuSections)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        // Request authorization if it was not granted previously.
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        startObservingData()
    }

    //----------------------------------------
    // MARK: - Observing data
    //----------------------------------------

    private func startObservingData() {
        currentLocationSubject
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] clLocation in
                guard let self = self,
                      let clLocation = clLocation else { return }

                let locationSection = HomeMenuSection(type: .location, menus: [.location(clLocation: clLocation)])

                var homeMenuSections = self.homeMenuSections
                homeMenuSections.removeAll(where: { $0.type == .location })
                homeMenuSections.append(locationSection)

                self.homeMenuSectionsSubject.send(homeMenuSections)
            }).store(in: &cancellables)
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let locationManager: CLLocationManager

    private var currentLocationSubject = CurrentValueSubject<CLLocation?, Never>(nil)

    private var homeMenuSectionsSubject = CurrentValueSubject<[HomeMenuSection], Never>([])
    var homeMenuSectionsPublisher: AnyPublisher<[HomeMenuSection], Never> {
        return homeMenuSectionsSubject.eraseToAnyPublisher()
    }
    var homeMenuSections: [HomeMenuSection] {
        return homeMenuSectionsSubject.value
    }
}

//----------------------------------------
// MARK:- CLLocationManager delegate
//----------------------------------------

extension HomeViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            currentLocationSubject.send(lastLocation)
        }
    }
}
