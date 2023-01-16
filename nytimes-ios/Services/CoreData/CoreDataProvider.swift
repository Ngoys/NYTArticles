import Foundation
import CoreData

class CoreDataProvider {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(coreDataStack: CoreDataStack) {
        self.mainContext = coreDataStack.mainContext
        self.backgroundContext = coreDataStack.backgroundContext
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func createOrUpdateArticle(article: Article, articleListingContentType: ArticleListingContentType) {
        var currentArticleDataModal: ArticleDataModal?
        let fetchRequest = ArticleDataModal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", article.id)

        backgroundContext.performAndWait {
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)

                if results.isEmpty {
                    currentArticleDataModal = ArticleDataModal(context: self.backgroundContext)

                    currentArticleDataModal?.id = article.id
                    currentArticleDataModal?.title = article.title
                    currentArticleDataModal?.publishedDate = article.publishedDate
                    currentArticleDataModal?.articleListingContentType = articleListingContentType.name
                } else {
                    currentArticleDataModal = results.first
                }

                self.saveInBackgroundContext()
            } catch {
                print("CoreDataProvider - createOrUpdateArticle() Error \(error)")
            }
        }
    }

    func fetchArticles(articleListingContentType: ArticleListingContentType) -> [Article] {
        do {
            let fetchRequest = ArticleDataModal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "articleListingContentType == %@", articleListingContentType.name)
            
            let articleDataModals = try mainContext.fetch(fetchRequest)

            return articleDataModals.map({ $0.toArticle() })
        } catch {
            return []
        }
    }

    func deleteAllArticles() {
        let fetchRequest = ArticleDataModal.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try mainContext.fetch(fetchRequest)
            results.forEach { result in
                mainContext.delete(result)
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

        backgroundContext.performAndWait {
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)

                if results.isEmpty {
                    currentDocumentArticleDataModal = DocumentArticleDataModal(context: self.backgroundContext)

                    currentDocumentArticleDataModal?.id = documentArticleId
                    currentDocumentArticleDataModal?.abstract = documentArticle.abstract
                    currentDocumentArticleDataModal?.publishedDate = documentArticle.publishedDate
                } else {
                    currentDocumentArticleDataModal = results.first
                }

                self.saveInBackgroundContext()
            } catch {
                print("CoreDataProvider - createOrUpdateDocumentArticle() Error \(error)")
            }
        }
    }

    func fetchDocumentArticles(keyword: String) -> [DocumentArticle] {
        do {
            let fetchRequest = DocumentArticleDataModal.fetchRequest()
            // [c] means case insensitive
            fetchRequest.predicate = NSPredicate(format: "abstract CONTAINS[c] %@", keyword)

            let documentArticleDataModals = try mainContext.fetch(fetchRequest)

            return documentArticleDataModals.map({ $0.toDocumentArticle() })
        } catch {
            return []
        }
    }

    func saveInMainContext() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch {
            mainContext.rollback()
            print("CoreDataProvider - saveInMainContext() Error \(error)")
        }
    }

    func saveInBackgroundContext() {
        do {
            try backgroundContext.save()
        } catch {
            backgroundContext.rollback()
            print("CoreDataProvider - saveInBackgroundContext() Error \(error)")
        }
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let mainContext: NSManagedObjectContext

    private let backgroundContext: NSManagedObjectContext
}
