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

        return articleStore.searchArticles(keyword: searchKeywordSubject.value)
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func updateSearchKeyword(keyword: String) {
        searchKeywordSubject.send(keyword)
    }

    //----------------------------------------
    // MARK: - Publishers
    //----------------------------------------

    private let searchKeywordSubject = CurrentValueSubject<String, Never>("")

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private let articleStore: ArticleStore
}
