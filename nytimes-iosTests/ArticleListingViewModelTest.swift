import XCTest
import Cuckoo
import Combine

class ArticleListingViewModelTest: BaseViewModel {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: ArticleListingViewModel!

    var mockArticleStore: MockArticleStore!

    var mockAPIClient: MockNYTimesAPIClient!

    var mockCoreDataStore: MockCoreDataStore!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel(articleListingContentType: ArticleListingContentType) {
        viewModel = ArticleListingViewModel(articleListingContentType: articleListingContentType, articleStore: mockArticleStore)
    }

    override func setUp() {
        mockAPIClient = MockNYTimesAPIClient(apiBaseURL: <#T##URL#>, httpClient: <#T##HTTPClient#>)
        mockArticleStore = MockArticleStore(apiClient: <#T##APIClient#>, coreDataStore: <#T##CoreDataStore#>)
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

}
