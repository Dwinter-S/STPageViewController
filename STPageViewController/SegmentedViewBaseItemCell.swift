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
    
    func setItemModel<T: SegmentedViewItemProtocol>(_ itemModel: T) {
        self.itemModel = itemModel
        let appearance = itemModel.isSelected ? itemModel.selectedAppearance : itemModel.normalAppearance
        backgroundColor = appearance.backgroundColor
        contentView.backgroundColor = appearance.contentBackgroundColor
        layer.borderColor = appearance.borderColor.cgColor
        layer.borderWidth = appearance.borderWidth
        layer.cornerRadius = appearance.cornerRadius
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let itemModel = itemModel else { return }
        let appearance = itemModel.isSelected ? itemModel.selectedAppearance : itemModel.normalAppearance
        contentView.frame = bounds.inset(by: appearance.contentEdgeInsets)
    }
}
