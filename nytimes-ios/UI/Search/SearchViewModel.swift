import Foundation
import Combine

class SearchViewModel: StatefulViewModel<[DocumentArticle]> {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    init(articleStore: ArticleStore) {
        self.articleStore = articleStore
        super.init()

        startObservingData()
    }

    //----------------------------------------
    // MARK: - Observing data
    //----------------------------------------

    private func startObservingData() {
        searchKeywordSubject
            .debounce(for: .milliseconds(600), scheduler: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] text in
                guard let self = self else { return }
                self.documentArticlesSubject.send([])
                self.retryInitialLoad()
            }).store(in: &cancellables)
    }

    //----------------------------------------
    // MARK: - Data loading
    //----------------------------------------

    override func load() -> AnyPublisher<[DocumentArticle], Error> {
        guard searchKeywordSubject.value.count > minimumSearchWordCount else {
            return Result.Publisher(.success([])).eraseToAnyPublisher()
        }

        print("SearchViewModel - searchDocumentArticles(keyword: \(searchKeywordSubject.value), pageNumber: \(pageNumber))")
        return articleStore.searchDocumentArticles(keyword: searchKeywordSubject.value, pageNumber: self.pageNumber)
            .map { documentArticles in
                documentArticles.forEach { documentArticle in
                    self.articleStore.createOrUpdateDocumentArticleDataModal(documentArticle: documentArticle)
                }

                var previousFetchedDocumentArticles =  self.pageNumber == 1 ? [] : self.documentArticlesSubject.value
    
                previousFetchedDocumentArticles.append(contentsOf: documentArticles)

                // There are some duplicates coming in from the API
                // Hence the removeDuplicates(), to prevent collectionView from crashing.
                // For example, https://api.nytimes.com/svc/search/v2/articlesearch.json?q=Cat&page=12&api-key=aBBpWBWdHveK5y5w9Cbln7kci0vNiT0g
                // and https://api.nytimes.com/svc/search/v2/articlesearch.json?q=Cat&page=13&api-key=aBBpWBWdHveK5y5w9Cbln7kci0vNiT0g
                // Last item of page 12 is the same as first item of page 13
                previousFetchedDocumentArticles.removeDuplicates()

                self.documentArticlesSubject.send(previousFetchedDocumentArticles)
                return previousFetchedDocumentArticles
            }.eraseToAnyPublisher()
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func updateSearchKeyword(keyword: String) {
        searchKeywordSubject.send(keyword)
    }

    func fetchCoreDataDocumentArticles() -> [DocumentArticle] {
        print("SearchViewModel - fetchCoreDataDocumentArticles(\(searchKeywordSubject.value))")
        return articleStore.fetchCoreDataDocumentArticles(keyword: searchKeywordSubject.value)
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let minimumSearchWordCount = 2

    var searchKeyword: String {
        return searchKeywordSubject.value
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let searchKeywordSubject = CurrentValueSubject<String, Never>("")

    private let documentArticlesSubject = CurrentValueSubject<[DocumentArticle], Never>([])

    private let articleStore: ArticleStore
}
