import UIKit
import Combine

class BaseStore: NSObject {

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return decoder
    }()

    private var cancellables: Set<AnyCancellable> = Set()
}
