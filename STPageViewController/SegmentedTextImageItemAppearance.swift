//
//  SegmentedTextImageItemAppearance.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/14.
//

import UIKit

struct SegmentedTextImageItemAppearance: SegmentedViewItemAppearance {
    let font: UIFont
    let textColor: UIColor
    var contentEdgeInsets: UIEdgeInsets = .zero
    var backgroundColor: UIColor = .clear
    var contentBackgroundColor: UIColor = .clear
    var borderColor: UIColor = .clear
    var borderWidth: CGFloat = 0
    var cornerRadius: CGFloat = 0
    init(font: UIFont,
         textColor: UIColor) {
        self.font = font
        self.textColor = textColor
    }
}
