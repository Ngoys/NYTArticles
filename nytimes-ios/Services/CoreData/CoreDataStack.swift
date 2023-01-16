import Foundation
import CoreData

class CoreDataStack {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("CoreDataStack - Error \(error)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let modelName = "NYTimes"
}
