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

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel(articleListingContentType: ArticleListingContentType) {
        viewModel = ArticleListingViewModel(articleListingContentType: articleListingContentType, articleStore: mockArticleStore)
    }

    override func setUp() {
        mockCoreDataStore = MockCoreDataStore(coreDataStack: mockCoreDataStack)
        mockArticleStore = MockArticleStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore)
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

}
