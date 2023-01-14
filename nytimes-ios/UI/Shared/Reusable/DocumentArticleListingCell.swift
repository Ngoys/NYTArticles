import UIKit

class DocumentArticleListingCell: UICollectionViewCell {
    
    //----------------------------------------
    // MARK: - View Model Binding
    //----------------------------------------
    
    func bindViewModel(_ viewModel: DocumentArticleListingCellViewModel) {
        titleLabel.text = viewModel.titleText
        dateLabel.text = viewModel.dateText
    }
    
    //----------------------------------------
    // MARK: - Sizing
    //----------------------------------------
    
    static func sizeThatFits(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 48)
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    @IBOutlet private var titleLabel: UILabel!

    @IBOutlet private var dateLabel: UILabel!
    
    @IBOutlet private var containerView: UIView!
}
