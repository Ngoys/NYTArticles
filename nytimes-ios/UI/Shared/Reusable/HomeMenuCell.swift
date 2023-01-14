import UIKit

class HomeMenuCell: UICollectionViewCell {
    
    //----------------------------------------
    // MARK: - View Model Binding
    //----------------------------------------
    
    func bindViewModel(_ viewModel: HomeMenuCellViewModel) {
        titleLabel.text = viewModel.titleText
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
    
    @IBOutlet private var containerView: UIView!

    @IBOutlet private var rightArrow: UIImageView!
}
