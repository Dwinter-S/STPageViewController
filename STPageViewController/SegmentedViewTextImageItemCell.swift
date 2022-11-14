//
//  SegmentedViewTextImageItemCell.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

class SegmentedViewTextImageItemCell: SegmentedViewBaseItemCell {
    let textLabel = UILabel()
    
    override func commonInit() {
        super.commonInit()
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
    }
    
    override func setItemModel<T: SegmentedViewItemProtocol>(_ itemModel: T) {
        super.setItemModel(itemModel)
        guard let textImageItemModel = itemModel as? SegmentedViewTextImageItemModel else {
            return
        }
//        self.textImageItemModel = textImageItemModel
        let appearance = textImageItemModel.isSelected ? textImageItemModel.selectedAppearance : textImageItemModel.normalAppearance
        textLabel.text = textImageItemModel.title
        textLabel.font = appearance.font
        textLabel.textColor = appearance.textColor
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = contentView.bounds
    }
}
