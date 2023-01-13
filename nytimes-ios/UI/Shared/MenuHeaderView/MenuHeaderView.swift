import Foundation
import UIKit

class MenuHeaderView: UICollectionReusableView {

    //----------------------------------------
    // MARK: - View Model Binding
    //----------------------------------------
    
    func bindViewModel(_ viewModel: MenuHeaderViewModel) {
        titleLabel.text = viewModel.title
    }
    
    //----------------------------------------
    // MARK: - Sizing
    //----------------------------------------
    
    static func sizeThatFits(width: CGFloat, isTitleEmpty: Bool = false) -> CGSize {
        return CGSize(width: width, height: isTitleEmpty ? 0.0 : 12 + 19 + 12)
    }
    
    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var titleLabel: UILabel!
}
