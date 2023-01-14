import UIKit
import Combine

class BaseViewModel: NSObject {

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    var cancellables: Set<AnyCancellable> = Set()
}
