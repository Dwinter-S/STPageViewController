//
//  SegmentedTextImageItemAppearance.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/14.
//

import UIKit

struct SegmentedTextImageItemAppearance: SegmentedViewItemAppearance {
    let title: String
    let font: UIFont
    let textColor: UIColor
    let baseAppearance: SegmentedViewItemBaseAppearance
    init(title: String,
         font: UIFont,
         textColor: UIColor,
         baseAppearance: SegmentedViewItemBaseAppearance = SegmentedViewItemBaseAppearance()) {
        self.title = title
        self.font = font
        self.textColor = textColor
        self.baseAppearance = baseAppearance
    }
    
    var itemSize: CGSize {
        if baseAppearance.fixedSize != .zero {
            return baseAppearance.fixedSize
        } else {
            let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            let textSize = (title as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
            let contentEdgeInsets = baseAppearance.contentEdgeInsets
            let width = textSize.width + contentEdgeInsets.left + contentEdgeInsets.right
            let height = textSize.height + contentEdgeInsets.top +  contentEdgeInsets.bottom
            return CGSize(width: width, height: height)
        }
    }
}
