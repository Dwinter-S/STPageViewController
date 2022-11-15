//
//  SegmentedItemAppearance.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

protocol SegmentedViewItemAppearance {
    var baseAppearance: SegmentedViewItemBaseAppearance { get }
    var itemSize: CGSize { get }
}

struct SegmentedViewItemBaseAppearance {
    var contentEdgeInsets: UIEdgeInsets = .zero
    var backgroundColor: UIColor = .clear
    var contentBackgroundColor: UIColor = .clear
    var borderColor: UIColor = .clear
    var borderWidth: CGFloat = 0
    var cornerRadius: CGFloat = 0
    var fixedSize: CGSize = .zero
}
