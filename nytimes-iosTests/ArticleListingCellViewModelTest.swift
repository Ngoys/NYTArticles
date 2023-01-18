import XCTest
import Cuckoo
import Combine
@testable import nytimes_ios

class ArticleListingCellViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: ArticleListingCellViewModel!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel(article: Article) {
        viewModel = ArticleListingCellViewModel(article: article)
    }

    override func setUp() {
        // No action
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testArticle(article: Article, expectedTitleText: String?, expectedDateText: String?) {
        setupViewModel(article: article)
        XCTAssertEqual(viewModel.titleText, expectedTitleText)
        XCTAssertEqual(viewModel.dateText, expectedDateText)
    }

    func testLabelTextOutput() {
        let calendar = Calendar.current

        let today = Date()
        let mockArticle1 = Article(id: "id", title: "test title", publishedDate: today)
        testArticle(article: mockArticle1, expectedTitleText: "test title", expectedDateText: "Today")

        let midnight = calendar.startOfDay(for: today)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!
        let mockArticle2 = Article(id: "id", title: "abc title", publishedDate: tomorrow)
        testArticle(article: mockArticle2, expectedTitleText: "abc title", expectedDateText: "Tomorrow")

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let mockPublishedDate = formatter.date(from: "2023/01/12")
        let mockArticle3 = Article(id: "id", title: "efg title", publishedDate: mockPublishedDate)
        testArticle(article: mockArticle3, expectedTitleText: "efg title", expectedDateText: "January 12, 2023")
    }
}
