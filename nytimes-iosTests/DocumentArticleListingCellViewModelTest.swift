import XCTest
import Cuckoo
import Combine
@testable import nytimes_ios

class DocumentArticleListingCellViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: DocumentArticleListingCellViewModel!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel(documentArticle: DocumentArticle) {
        viewModel = DocumentArticleListingCellViewModel(documentArticle: documentArticle)
    }

    override func setUp() {
        // No action
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testDocumentArticle(documentArticle: DocumentArticle, expectedTitleText: String?, expectedDateText: String?) {
        setupViewModel(documentArticle: documentArticle)
        XCTAssertEqual(viewModel.titleText, expectedTitleText)
        XCTAssertEqual(viewModel.dateText, expectedDateText)
    }

    func testLabelTextOutput() {
        let calendar = Calendar.current

        let today = Date()
        let mockArticle1 = DocumentArticle(id: "id", abstract: "test title", publishedDate: today)
        testDocumentArticle(documentArticle: mockArticle1, expectedTitleText: "test title", expectedDateText: "Today")

        let midnight = calendar.startOfDay(for: today)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!
        let mockArticle2 = DocumentArticle(id: "id", abstract: "abc title", publishedDate: tomorrow)
        testDocumentArticle(documentArticle: mockArticle2, expectedTitleText: "abc title", expectedDateText: "Tomorrow")

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let mockPublishedDate = formatter.date(from: "2023/01/12")
        let mockArticle3 = DocumentArticle(id: "id", abstract: "efg title", publishedDate: mockPublishedDate)
        testDocumentArticle(documentArticle: mockArticle3, expectedTitleText: "efg title", expectedDateText: "January 12, 2023")
    }
}
