//
//  SegmentedViewBaseItemCell.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/14.
//

import UIKit

class SegmentedViewBaseItemCell: UICollectionViewCell {
    var itemModel: SegmentedViewItemProtocol?
    lazy var redPointView = UIView()
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
    
    func setRedDot(_ redDotInfo: SegmentedViewRedDot) {
        if redPointView.superview == nil {
            contentView.addSubview(redPointView)
            redPointView.snp.makeConstraints {
                $0.top.equalTo(redDotInfo.offset.y)
                $0.right.equalTo(redDotInfo.offset.x)
                $0.size.equalTo(redDotInfo.size)
            }
            redPointView.backgroundColor = redDotInfo.color
            redPointView.layer.cornerRadius = redDotInfo.size.width / 2
        }
        redPointView.isHidden = !redDotInfo.display
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let itemModel = itemModel else { return }
        let appearance = itemModel.currentAppearance
        contentView.frame = bounds.inset(by: appearance.baseAppearance.contentEdgeInsets)
    }
}
