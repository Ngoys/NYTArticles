import UIKit

protocol SearchViewControllerDelegate: NSObjectProtocol {
}

class SearchViewController: BaseViewController {

    class func fromStoryboard() -> (UINavigationController, SearchViewController) {
        let navigationController = R.storyboard.search().instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! SearchViewController)
    }

    //----------------------------------------
    // MARK:- Section
    //----------------------------------------

    enum Section: Int, Hashable {
        case main, loading
    }

    //----------------------------------------
    // MARK: - Type aliases
    //----------------------------------------

    typealias DataSource = UICollectionViewDiffableDataSource<Section, DocumentArticle>

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DocumentArticle>

    //----------------------------------------
    // MARK:- View model
    //----------------------------------------

    var viewModel: SearchViewModel!

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: SearchViewControllerDelegate?

    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------

    override func configureViews() {
        navigationItem.title = R.string.localizable.articles().capitalized
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

        collectionView.register(R.nib.documentArticleListingCell)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)

        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.delegate = self

        searchBar.delegate = self
        searchBar.placeholder = R.string.localizable.type_something_here()

        searchBar.becomeFirstResponder()
    }

    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------

    override func bindViewModel() {
        viewModel.statePublisher
            .sink { [weak self] state in
                guard let self = self else { return }

                self.statefulPlaceholderView.bind(state)

                switch state {
                case .loaded(let documentArticles):
                    self.applySnapshot(documentArticles: documentArticles)

                default:
                    break
                }
            }.store(in: &cancellables)
    }

    //----------------------------------------
    // MARK: - UICollectionView layout
    //----------------------------------------

    func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var cellSize: CGSize!
            var itemSize: NSCollectionLayoutSize!
            var group: NSCollectionLayoutGroup!
            var item: NSCollectionLayoutItem!
            var section: NSCollectionLayoutSection!
            let containerWidth = layoutEnvironment.container.contentSize.width

            cellSize = DocumentArticleListingCell.sizeThatFits(width: containerWidth)
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(cellSize.height))
            item = NSCollectionLayoutItem(layoutSize: itemSize)
            group = .vertical(layoutSize: itemSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)

            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    //----------------------------------------
    // MARK: - UICollectionView data source
    //----------------------------------------

    private func applySnapshot(documentArticles: [DocumentArticle], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(documentArticles)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.documentArticleListingCell, for: indexPath) as! DocumentArticleListingCell
                let viewModel = DocumentArticleListingCellViewModel(documentArticle: item)
                cell.bindViewModel(viewModel)

                return cell
            })

        return dataSource
    }

    private lazy var dataSource = createDataSource()

    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var statefulPlaceholderView: StatefulPlaceholderView!

    @IBOutlet private var collectionView: UICollectionView!

    @IBOutlet private var searchBar: UISearchBar!
}

//----------------------------------------
// MARK: - UICollectionView delegate
//----------------------------------------

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == collectionView.numberOfItems(inSection: Section.main.rawValue) - 1 {
            // Load more when it reaches the last row
            viewModel.loadNextPage()
        }
    }
}

//----------------------------------------
// MARK: - UISearchBar delegate
//----------------------------------------

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchKeyword(keyword: searchText)
    }
}
