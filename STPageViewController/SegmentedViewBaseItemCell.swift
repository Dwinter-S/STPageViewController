//
//  SegmentedViewBaseItemCell.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/14.
//

import UIKit

class SegmentedViewBaseItemCell: UICollectionViewCell {
    var itemModel: SegmentedViewItemProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        
    }
    
    func setItemModel(_ itemModel: SegmentedViewItemProtocol) {
        self.itemModel = itemModel
        let appearance = itemModel.currentAppearance.baseAppearance
        backgroundColor = appearance.backgroundColor
        contentView.backgroundColor = appearance.contentBackgroundColor
        layer.borderColor = appearance.borderColor.cgColor
        layer.borderWidth = appearance.borderWidth
        layer.cornerRadius = appearance.cornerRadius
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let itemModel = itemModel else { return }
        let appearance = itemModel.currentAppearance
        contentView.frame = bounds.inset(by: appearance.baseAppearance.contentEdgeInsets)
    }
}
