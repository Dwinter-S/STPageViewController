//
//  SegmentedItemAppearance.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

//class SegmentedViewBaseItemAppearance {
//    var contentEdgeInsets: UIEdgeInsets = .zero
//    var backgroundColor: UIColor = .clear
//    var contentBackgroundColor: UIColor = .clear
//    var borderColor: UIColor = .clear
//    var borderWidth: CGFloat = 0
//    var cornerRadius: CGFloat = 0
////    init(contentEdgeInsets: UIEdgeInsets, backgroundColor: UIColor, contentBackgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
////        self.contentEdgeInsets = contentEdgeInsets
////        self.backgroundColor = backgroundColor
////        self.contentBackgroundColor = contentBackgroundColor
////        self.borderColor = borderColor
////        self.borderWidth = borderWidth
////        self.cornerRadius = cornerRadius
////    }
//}

protocol SegmentedViewItemAppearance {
    var contentEdgeInsets: UIEdgeInsets { get set }
    var backgroundColor: UIColor { get set }
    var contentBackgroundColor: UIColor { get set }
    var borderColor: UIColor { get set }
    var borderWidth: CGFloat { get set }
    var cornerRadius: CGFloat { get set }
}
