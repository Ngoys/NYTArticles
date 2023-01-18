import XCTest
import Cuckoo
import Combine
@testable import nytimes_ios

class ArticleListingViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: ArticleListingViewModel!

    var mockArticleStore: MockArticleStore!

    var mockCoreDataStore: MockCoreDataStore!

    let mockArticles = [
        Article(id: "1", title: "title1", publishedDate: Date()),
        Article(id: "2", title: "title2", publishedDate: Date()),
        Article(id: "3", title: "title3", publishedDate: Date()),
    ]

    let mockCoreDataArticles = [
        Article(id: "1", title: "coreDatatitle1", publishedDate: Date()),
        Article(id: "2", title: "coreDatatitle2", publishedDate: Date()),
        Article(id: "3", title: "coreDatatitle3", publishedDate: Date()),
    ]

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel(articleListingContentType: ArticleListingContentType) {
        viewModel = ArticleListingViewModel(articleListingContentType: articleListingContentType, articleStore: mockArticleStore)
    }

    override func setUp() {
        super.setUp()

        mockCoreDataStore = MockCoreDataStore(coreDataStack: mockCoreDataStack)
        mockArticleStore = MockArticleStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore)

        Cuckoo.stub(mockArticleStore) { stub in
            when(stub.fetchArticles(articleListingContentType: any())).thenReturn(Result.Publisher(.success(mockArticles))
                .eraseToAnyPublisher())
            when(stub.createOrUpdateArticleDataModal(article: any(), articleListingContentType: any())).thenDoNothing()
        }
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testArticlesLoad(articleListingContentType: ArticleListingContentType, articles: [Article]) {
        setupViewModel(articleListingContentType: articleListingContentType)

        verify(mockArticleStore).fetchArticles(articleListingContentType: articleListingContentType)
        verify(mockArticleStore, times(articles.count)).createOrUpdateArticleDataModal(article: any(), articleListingContentType: articleListingContentType)

        viewModel.load().sink(receiveCompletion: { completion in
        }, receiveValue: { value in
            XCTAssert(value == articles)
        }).store(in: &cancellables)
    }

    func testArticlesLoad() {
        testArticlesLoad(articleListingContentType: .mostViewed, articles: mockArticles)
        testArticlesLoad(articleListingContentType: .mostShared, articles: mockArticles)
        testArticlesLoad(articleListingContentType: .mostEmailed, articles: mockArticles)
    }

    func testArticlesCoreDataLoad(articleListingContentType: ArticleListingContentType, articles: [Article]) {
        setupViewModel(articleListingContentType: articleListingContentType)

        Cuckoo.stub(mockArticleStore) { stub in
            when(stub.fetchCoreDataArticles(articleListingContentType: articleListingContentType)).thenReturn(articles)
        }

        XCTAssert(viewModel.fetchCoreDataArticles() == articles)

        verify(mockArticleStore).fetchCoreDataArticles(articleListingContentType: articleListingContentType)
    }

    func testArticlesCoreDataLoad() {
        testArticlesCoreDataLoad(articleListingContentType: .mostViewed, articles: mockCoreDataArticles)
        testArticlesCoreDataLoad(articleListingContentType: .mostShared, articles: mockCoreDataArticles)
        testArticlesCoreDataLoad(articleListingContentType: .mostEmailed, articles: mockCoreDataArticles)
    }

    func testArticlesLoadError(articleListingContentType: ArticleListingContentType, appError: AppError) {
        Cuckoo.stub(mockArticleStore) { stub in
            when(stub.fetchArticles(articleListingContentType: any())).thenReturn(Result.Publisher(.failure(appError))
                .eraseToAnyPublisher())
        }

        setupViewModel(articleListingContentType: articleListingContentType)

        verify(mockArticleStore).fetchArticles(articleListingContentType: articleListingContentType)
        verify(mockArticleStore, never()).createOrUpdateArticleDataModal(article: any(), articleListingContentType: articleListingContentType)

        viewModel.load().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail("Should not execute this block clause")

            case .failure(let error):
                XCTAssertEqual(error as? AppError, appError)
            }
        }, receiveValue: { value in
            XCTFail("Should not execute this block clause")
        }).store(in: &cancellables)
    }

    func testArticlesLoadError() {
        testArticlesLoadError(articleListingContentType: .mostViewed, appError: .invalidData)
        testArticlesLoadError(articleListingContentType: .mostShared, appError: .authentication)
        testArticlesLoadError(articleListingContentType: .mostEmailed, appError: .quotaViolation)
    }
}
