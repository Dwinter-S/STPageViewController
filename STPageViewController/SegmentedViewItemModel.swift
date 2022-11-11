//
//  SegmentedViewItemModel.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import Foundation
import UIKit

class SegmentedViewItemModel {
    var cellClass: UICollectionViewCell.Type = SegmentedViewItemCell.self
    var title: String = ""
    var isSelected: Bool = false
    var normalAppearance = SegmentedViewItemAppearance(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.black)
    var selectedAppearance = SegmentedViewItemAppearance(font: UIFont.systemFont(ofSize: 16), textColor: UIColor.red)
    
    var itemWidth: CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let font = isSelected ? selectedAppearance.font : normalAppearance.font
        let textSize = (title as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return textSize.width
    }
}
