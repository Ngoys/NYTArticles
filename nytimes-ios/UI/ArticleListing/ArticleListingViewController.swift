import UIKit

protocol ArticleListingViewControllerDelegate: NSObjectProtocol {
}

class ArticleListingViewController: BaseViewController {

    class func fromStoryboard() -> (UINavigationController, ArticleListingViewController) {
        let navigationController = R.storyboard.articleListing().instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! ArticleListingViewController)
    }

    //----------------------------------------
    // MARK:- Section
    //----------------------------------------

    enum Section: Int, Hashable {
        case main
    }

    //----------------------------------------
    // MARK: - Type aliases
    //----------------------------------------

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Article>

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Article>

    //----------------------------------------
    // MARK:- View model
    //----------------------------------------

    var viewModel: ArticleListingViewModel!

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: ArticleListingViewControllerDelegate?

    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------

    override func configureViews() {
        navigationItem.title = R.string.localizable.articles().capitalized
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

        collectionView.register(R.nib.articleListingCell)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)

        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.delegate = self
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
                case .loaded(let articles):
                    self.applySnapshot(articles: articles)

                case .loadingFailed:
                    let articles = self.viewModel.fetchCoreDataArticles()

                    self.statefulPlaceholderView.isHidden = articles.isEmpty == false
                    self.applySnapshot(articles: articles)

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

            cellSize = ArticleListingCell.sizeThatFits(width: containerWidth)
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

    private func applySnapshot(articles: [Article], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.articleListingCell, for: indexPath) as! ArticleListingCell
                let viewModel = ArticleListingCellViewModel(article: item)
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
}

//----------------------------------------
// MARK: - UICollectionView delegate
//----------------------------------------

extension ArticleListingViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
