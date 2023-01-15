import Foundation
import CoreData

extension ArticleDataModal {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    @NSManaged public var id: Int
    @NSManaged public var title: String?
    @NSManaged public var publishedDate: Date?

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    static func fetchRequest() -> NSFetchRequest<ArticleDataModal> {
        return NSFetchRequest<ArticleDataModal>(entityName: "ArticleDataModal")
    }

    func toArticle() -> Article {
        return Article(id: id, title: title, publishedDate: publishedDate)
    }
}
