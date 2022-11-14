//
//  SegmentedViewItemModel.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import Foundation
import UIKit

//struct SegmentedViewItemModel {
//    var cellClass: UICollectionViewCell.Type
//    var isSelected: Bool
//    var fixedItemSize: CGSize = .zero
//    let normalAppearance: SegmentedTextImageItemAppearance
//    let selectedAppearance: SegmentedTextImageItemAppearance
//
////    init(normalAppearance: SegmentedViewBaseItemAppearance,
////         selectedAppearance: SegmentedViewBaseItemAppearance) {
////        self.cellClass = cellClass
////        self.isSelected = isSelected
////        self.normalAppearance = normalAppearance
////        self.selectedAppearance = selectedAppearance
////        self.fixedItemSize = fixedItemSize
////    }
//}


protocol SegmentedViewItemProtocol {
    var cellClass: UICollectionViewCell.Type { get set }
    var isSelected: Bool { get set }
    var fixedItemSize: CGSize { get set }
    var itemSize: CGSize { get }
    var normalAppearance: SegmentedTextImageItemAppearance { get set }
    var selectedAppearance: SegmentedTextImageItemAppearance { get set }
    mutating func setSelected(_ selected: Bool)
}
