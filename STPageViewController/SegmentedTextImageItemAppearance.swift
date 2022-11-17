//
//  SegmentedTextImageItemAppearance.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/14.
//

import UIKit

struct SegmentedTextImageItemAppearance: SegmentedViewItemAppearance {
    var text: String?
    var font: UIFont?
    var textColor: UIColor?
    var attributeText: NSAttributedString?
    var baseAppearance: SegmentedViewItemBaseAppearance
//    var itemSize: CGSize
    init(text: String,
         font: UIFont,
         textColor: UIColor,
         baseAppearance: SegmentedViewItemBaseAppearance = SegmentedViewItemBaseAppearance()) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.baseAppearance = baseAppearance
    }
    
    init(attributeText: NSAttributedString, baseAppearance: SegmentedViewItemBaseAppearance = SegmentedViewItemBaseAppearance()) {
        self.attributeText = attributeText
        self.baseAppearance = baseAppearance
    }
    
    var itemSize: CGSize {
        if baseAppearance.fixedSize != .zero {
            return baseAppearance.fixedSize
        } else {
            var textSize: CGSize = .zero
            let boundingRectSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            if let attributeText = attributeText {
                textSize = attributeText.boundingRect(with: boundingRectSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
            } else if let text = text, let font = font {
                textSize = (text as NSString).boundingRect(with: boundingRectSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil).size
            }
            let contentEdgeInsets = baseAppearance.contentEdgeInsets
            let width = textSize.width + contentEdgeInsets.left + contentEdgeInsets.right
            let height = textSize.height + contentEdgeInsets.top +  contentEdgeInsets.bottom
            return CGSize(width: width, height: height)
        }
    }
}
