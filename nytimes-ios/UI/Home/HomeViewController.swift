import UIKit

protocol HomeViewControllerDelegate: NSObjectProtocol {

    func homeViewControllerDidSelectSearchArticle(_ homeViewController: HomeViewController)

    func homeViewControllerDidSelectMostViewed(_ homeViewController: HomeViewController)

    func homeViewControllerDidSelectMostShared(_ homeViewController: HomeViewController)

    func homeViewControllerDidSelectMostEmailed(_ homeViewController: HomeViewController)
}

class HomeViewController: BaseViewController {

    class func fromStoryboard() -> (UINavigationController, HomeViewController) {
        let navigationController = R.storyboard.home().instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! HomeViewController)
    }

    //----------------------------------------
    // MARK: - Type aliases
    //----------------------------------------

    typealias DataSource = UICollectionViewDiffableDataSource<HomeMenuSection, HomeMenu>

    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeMenuSection, HomeMenu>

    //----------------------------------------
    // MARK:- View model
    //----------------------------------------

    var viewModel: HomeViewModel!

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: HomeViewControllerDelegate?

    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------

    override func configureViews() {
        navigationItem.title = R.string.localizable.new_york_times()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

        collectionView.register(UINib(resource: R.nib.menuHeaderView),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: R.nib.menuHeaderView.name)
        collectionView.register(R.nib.homeMenuCell)

        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.delegate = self
    }

    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------

    override func bindViewModel() {
        viewModel.homeMenuSectionsPublisher
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] homeMenuSections in
                guard let self = self else { return }
                self.applySnapshot(homeMenuSections: homeMenuSections, animatingDifferences: false)
            }).store(in: &cancellables)
    }

    //----------------------------------------
    // MARK: - UICollectionView layout
    //----------------------------------------

    func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var cellSize: CGSize!
            var itemSize: NSCollectionLayoutSize!
            var group: NSCollectionLayoutGroup!
            var headerSize: CGSize!
            var item: NSCollectionLayoutItem!
            var section: NSCollectionLayoutSection!
            let containerWidth = layoutEnvironment.container.contentSize.width

            let homeMenuSection = self.viewModel.homeMenuSections[sectionIndex]

            headerSize = MenuHeaderView.sizeThatFits(width: containerWidth)
            let headerLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .absolute(headerSize.height))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerLayoutSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)

            cellSize = HomeMenuCell.sizeThatFits(width: containerWidth)
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(cellSize.height))
            item = NSCollectionLayoutItem(layoutSize: itemSize)
            group = .vertical(layoutSize: itemSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)

            switch homeMenuSection.type {
            case .search:
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 28, trailing: 0)
                section.boundarySupplementaryItems = [header]

            case .popular:
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 28, trailing: 0)
                section.boundarySupplementaryItems = [header]

            case .location:
                section.boundarySupplementaryItems = [header]
            }

            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    //----------------------------------------
    // MARK: - UICollectionView data source
    //----------------------------------------

    private func applySnapshot(homeMenuSections: [HomeMenuSection], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(homeMenuSections)
        homeMenuSections.forEach {
            snapshot.appendItems($0.menus, toSection: $0)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.homeMenuCell, for: indexPath) as! HomeMenuCell
                let viewModel = HomeMenuCellViewModel(homeMenu: item)
                cell.bindViewModel(viewModel)

                return cell
            })

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: R.nib.menuHeaderView.name,
                                                                       for: indexPath) as! MenuHeaderView
            let viewModel = MenuHeaderViewModel(title: section.type.name)
            view.bindViewModel(viewModel)

            return view
        }
        return dataSource
    }

    private lazy var dataSource = createDataSource()

    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------

    @IBOutlet private var collectionView: UICollectionView!
}

//----------------------------------------
// MARK: - UICollectionView delegate
//----------------------------------------

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeMenu = viewModel.homeMenuSections[indexPath.section].menus[indexPath.item]

        switch homeMenu {
        case .searchArticle:
            delegate?.homeViewControllerDidSelectSearchArticle(self)

        case .mostViewed:
            delegate?.homeViewControllerDidSelectMostViewed(self)

        case .mostShared:
            delegate?.homeViewControllerDidSelectMostShared(self)

        case .mostEmailed:
            delegate?.homeViewControllerDidSelectMostEmailed(self)

        case .location(_):
            break
        }
    }
}
