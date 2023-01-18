import Cuckoo
@testable import nytimes_ios

extension ArticleListingContentType: Matchable {
    public var matcher: ParameterMatcher<ArticleListingContentType> {
        return ParameterMatcher {
            return $0 == self
        }
    }
}
