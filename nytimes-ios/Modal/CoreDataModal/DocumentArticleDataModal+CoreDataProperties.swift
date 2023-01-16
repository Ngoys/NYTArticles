import Foundation
import CoreData

extension DocumentArticleDataModal {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    @NSManaged public var id: String?
    @NSManaged public var abstract: String?
    @NSManaged public var publishedDate: Date?

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    static func fetchRequest() -> NSFetchRequest<DocumentArticleDataModal> {
        return NSFetchRequest<DocumentArticleDataModal>(entityName: "DocumentArticleDataModal")
    }

    func toDocumentArticle() -> DocumentArticle {
        return DocumentArticle(id: id, abstract: abstract, publishedDate: publishedDate)
    }
}
