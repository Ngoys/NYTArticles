import Foundation
import CoreData

class CoreDataProvider {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func createOrUpdateArticle(article: Article) { //shawn category
        var currentArticleDataModal: ArticleDataModal?
        let newsPostFetch: NSFetchRequest<ArticleDataModal> = ArticleDataModal.fetchRequest()

        //shawn
        let newsItemIDPredicate = NSPredicate(format: "%K == %i", #keyPath(ArticleDataModal.id), article.id)
        newsPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])

        do {
            let results = try context.fetch(newsPostFetch)

            if results.isEmpty {
                currentArticleDataModal = ArticleDataModal(context: context)

                currentArticleDataModal?.id = article.id
                currentArticleDataModal?.title = article.title
                currentArticleDataModal?.publishedDate = article.publishedDate
            } else {
                currentArticleDataModal = results.first
            }

            save()
        } catch {
            print("CoreDataProvider - createOrUpdateArticle() Error \(error)")
        }
    }

    func fetchArticles() -> [Article] {
        do {
            let articleDataModals = try context.fetch(ArticleDataModal.fetchRequest())
            return articleDataModals.map({ $0.toArticle() })
        } catch {
            return []
        }
    }

    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("CoreDataProvider - save() Error \(error)")
        }
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let context: NSManagedObjectContext
}
