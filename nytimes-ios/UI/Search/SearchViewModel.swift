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

        return articleStore.searchDocumentArticles(keyword: searchKeywordSubject.value, pageNumber: self.pageNumber)
            .map { documentArticles in
                var previousFetchedDocumentArticles =  self.pageNumber == 1 ? [] : self.documentArticlesSubject.value
    
                previousFetchedDocumentArticles.append(contentsOf: documentArticles)
                
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

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let minimumSearchWordCount = 2

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let searchKeywordSubject = CurrentValueSubject<String, Never>("")

    private let documentArticlesSubject = CurrentValueSubject<[DocumentArticle], Never>([])

    private let articleStore: ArticleStore
}
