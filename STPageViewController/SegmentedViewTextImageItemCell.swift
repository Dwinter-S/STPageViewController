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
    
    override func setItemModel(_ itemModel: SegmentedViewItemProtocol) {
        super.setItemModel(itemModel)
        guard let appearance = itemModel.currentAppearance as? SegmentedTextImageItemAppearance else {
            return
        }
//        self.textImageItemModel = textImageItemModel
        if let attributeText = appearance.attributeText {
            textLabel.attributedText = attributeText
        } else {
            textLabel.text = appearance.text
            textLabel.font = appearance.font
            textLabel.textColor = appearance.textColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = contentView.bounds
    }
}
