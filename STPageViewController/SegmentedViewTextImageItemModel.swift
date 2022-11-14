//
//  SegmentedViewTextImageItemModel.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/14.
//

import UIKit

struct SegmentedViewTextImageItemModel: SegmentedViewItemProtocol {
    
    
    var cellClass: UICollectionViewCell.Type = SegmentedViewTextImageItemCell.self
    var normalAppearance = SegmentedTextImageItemAppearance(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black)
    var selectedAppearance = SegmentedTextImageItemAppearance(font: UIFont.systemFont(ofSize: 16), textColor: UIColor.red)
    var title: String = ""
    var isSelected: Bool = false
    var fixedItemSize: CGSize = .zero
    
    mutating func setSelected(_ selected: Bool) {
        isSelected = selected
    }
    
    var itemSize: CGSize {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let appearance = isSelected ? selectedAppearance : normalAppearance
        let textSize = (title as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: appearance.font], context: nil)
        let width = textSize.width + appearance.contentEdgeInsets.left + appearance.contentEdgeInsets.right
        let height = textSize.height + appearance.contentEdgeInsets.top +  appearance.contentEdgeInsets.bottom
        return CGSize(width: width, height: height)
    }
    
}
