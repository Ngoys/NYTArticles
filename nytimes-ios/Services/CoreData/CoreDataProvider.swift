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

    func createOrUpdateArticle(article: Article, articleListingContentType: ArticleListingContentType) {
        var currentArticleDataModal: ArticleDataModal?
        let fetchRequest = ArticleDataModal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", article.id)

        do {
            let results = try context.fetch(fetchRequest)

            if results.isEmpty {
                currentArticleDataModal = ArticleDataModal(context: context)

                currentArticleDataModal?.id = article.id
                currentArticleDataModal?.title = article.title
                currentArticleDataModal?.publishedDate = article.publishedDate
                currentArticleDataModal?.articleListingContentType = articleListingContentType.name
            } else {
                currentArticleDataModal = results.first
            }

            save()
        } catch {
            print("CoreDataProvider - createOrUpdateArticle() Error \(error)")
        }
    }

    func fetchArticles(articleListingContentType: ArticleListingContentType) -> [Article] {
        do {
            let fetchRequest = ArticleDataModal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "articleListingContentType == %@", articleListingContentType.name)
            
            let articleDataModals = try context.fetch(fetchRequest)

            return articleDataModals.map({ $0.toArticle() })
        } catch {
            return []
        }
    }

    func deleteAllArticles() {
        let fetchRequest = ArticleDataModal.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { result in
                context.delete(result)
            }
        } catch {
            print("CoreDataProvider - deleteAllArticles() Error \(error)")
        }
    }

    func createOrUpdateDocumentArticle(documentArticle: DocumentArticle) {
        guard let documentArticleId = documentArticle.id else { return }

        var currentDocumentArticleDataModal: DocumentArticleDataModal?
        let fetchRequest = DocumentArticleDataModal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", documentArticleId)

        do {
            let results = try context.fetch(fetchRequest)

            if results.isEmpty {
                currentDocumentArticleDataModal = DocumentArticleDataModal(context: context)

                currentDocumentArticleDataModal?.id = documentArticleId
                currentDocumentArticleDataModal?.abstract = documentArticle.abstract
                currentDocumentArticleDataModal?.publishedDate = documentArticle.publishedDate
            } else {
                currentDocumentArticleDataModal = results.first
            }

            save()
        } catch {
            print("CoreDataProvider - createOrUpdateDocumentArticle() Error \(error)")
        }
    }

    func fetchDocumentArticles(keyword: String) -> [DocumentArticle] {
        do {
            let fetchRequest = DocumentArticleDataModal.fetchRequest()
            // [c] means case insensitive
            fetchRequest.predicate = NSPredicate(format: "abstract CONTAINS[c] %@", keyword)

            let documentArticleDataModals = try context.fetch(fetchRequest)

            return documentArticleDataModals.map({ $0.toDocumentArticle() })
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
