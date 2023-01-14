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
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] text in
                guard let self = self else { return }

                self.retryInitialLoad()
            }).store(in: &cancellables)
    }

    //----------------------------------------
    // MARK: - Data loading
    //----------------------------------------

    override func load() -> AnyPublisher<[DocumentArticle], Error> {
        guard searchKeywordSubject.value.isEmpty == false else {
            return Result.Publisher(.success([]))
                .eraseToAnyPublisher()
        }

        return articleStore.searchDocumentArticles(keyword: searchKeywordSubject.value, pageNumber: self.pageNumber)
            .map { documentArticles in
                var previousFetchedDocumentArticles = self.documentArticles.value
                previousFetchedDocumentArticles.append(contentsOf: documentArticles)
                
                self.documentArticles.send(previousFetchedDocumentArticles)
                return self.documentArticles.value
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

    private let searchKeywordSubject = CurrentValueSubject<String, Never>("")

    private let documentArticles = CurrentValueSubject<[DocumentArticle], Never>([])

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let articleStore: ArticleStore
}
