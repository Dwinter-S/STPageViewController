//
//  SegmentedViewItemCell.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

class SegmentedViewItemCell: UICollectionViewCell {
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        contentView.addSubview(textLabel)
    }
    
    func setItemModel(_ itemModel: SegmentedViewItemModel) {
        textLabel.text = itemModel.title
        let appearance = itemModel.isSelected ? itemModel.selectedAppearance : itemModel.normalAppearance
        textLabel.font = appearance.font
        textLabel.textColor = appearance.textColor
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.center = contentView.center
    }
}
