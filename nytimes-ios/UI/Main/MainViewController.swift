import UIKit
import Combine

protocol BaseAnalyticService: HomeAnalyticService, SearchAnalyticService, SettingsAnalyticService {

}
protocol HomeAnalyticService {
    func homeButtonDidTap()
}

protocol SearchAnalyticService {
    func searchItemDidTap(keyword: String)
}

protocol SettingsAnalyticService {
    func settingsDidTap(userID: String)
}

class AppAnalyticService: BaseAnalyticService {

    init (analyticServices: [BaseAnalyticService]) {
        self.analyticServices = analyticServices
    }

    func homeButtonDidTap() {
        self.analyticServices.forEach { analyticService in
            analyticService.homeButtonDidTap()
        }
    }

    func searchItemDidTap(keyword: String) {

    }

    func settingsDidTap(userID: String) {

    }

    private let analyticServices: [BaseAnalyticService]
}

//import FirebaseAnalytics

class FirebaseAnalyticService: BaseAnalyticService {
    func homeButtonDidTap() {
//        var parameters: [String: Any] = [:]
//
//        parameters[AnalyticsParameterItemID] = assetId
//        parameters["component_id"] = componentId
//
//        Analytics.logEvent("podcast_play", parameters: parameters)
    }

    func searchItemDidTap(keyword: String) {

    }

    func settingsDidTap(userID: String) {

    }
}

protocol MainViewControllerDelegate: NSObjectProtocol {
}

class MainViewController: BaseViewController {

    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------

    override func configureViews() {
        let aMinute = 60
        let aHour = 60 * aMinute
        let aDay = 24 * aHour
        let aWeek = 7 * aDay
        let aMonth = 30 * aDay
        let aYear = 12 * aMonth

        let seconds = (2 * aYear) + (4 * aMonth) + (3 * aWeek) + aDay + (23 * aHour) + (61 * aMinute) + 5

        let years = seconds / aYear
        let months = (seconds % aYear) / aMonth
        let weeks = (seconds % aMonth) / aWeek
        let days = (seconds % aWeek) / aDay
        let hours = (seconds % aDay) / aHour
        let minutes = (seconds % aHour) / aMinute
        let remainingSeconds = seconds % aMinute

        print("hello")

//        let a = PassthroughSubject<String, Never>()
//        a.send("meow")
//        a.send("wofff")
//        a.sink { [weak self] value in
//            print(value)
//        }.store(in: &cancellables)
//        a.send("haha") //printed
//        a.send("hehe") //printed

//        let a = CurrentValueSubject<String, Never>("start")
//        a.send("meow")
//        a.send("wofff") //printed
//        a.sink { [weak self] value in
//            print(value)
//        }.store(in: &cancellables)
//        a.send("haha") //printed
//        a.send("hehe") //printed

        printThis { value in
//            print(value)
        }
//        let a = getItem(Article(id: ""))

        DispatchQueue.main.async {

        }

        DispatchQueue.global(qos: .default).async {

        }

            let northZone = DispatchQueue(label: "perform_task_with_team_north", attributes: .concurrent)

            northZone.async {
                for numer in 1...3 { print("North \(numer)") }
        }
        northZone.async {
            for numer in 4...6 { print("South \(numer)") }
        }
    }

    func printThis(completion: (String) -> Void) {
        completion("meow")
    }

    func getItem<T: Equatable>(_ item: T) -> T {
        return item
    }

    lazy var haha: String = {
        return "ghaha"
    }()

    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------

    override func bindViewModel() {

    }

    //----------------------------------------
    // MARK: - View model
    //----------------------------------------

    var viewModel: MainViewModel!

    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------

    weak var delegate: MainViewControllerDelegate?
}
