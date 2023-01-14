import UIKit
import Combine

class BaseStore: NSObject {

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            // https://stackoverflow.com/a/50850604/18209126
            
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            self.formatter.dateFormat = "yyyy-MM-dd"
            if let date = self.formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()

    var cancellables: Set<AnyCancellable> = Set()

    private let formatter = DateFormatter()
}
