//
//  SegmentedViewItemProtocol.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

protocol SegmentedViewItemProtocol {
    var cellClass: UICollectionViewCell.Type { get }
    var isSelected: Bool { get set }
    func itemSize(isSelected: Bool) -> CGSize
    var itemCurrentSize: CGSize { get }
    var normalAppearance: SegmentedViewItemAppearance { get set }
    var selectedAppearance: SegmentedViewItemAppearance { get set }
    var currentAppearance: SegmentedViewItemAppearance { get }
}

extension SegmentedViewItemProtocol {
    var currentAppearance: SegmentedViewItemAppearance {
        return isSelected ? selectedAppearance : normalAppearance
    }
    var itemCurrentSize: CGSize {
        return itemSize(isSelected: isSelected)
    }
    func itemSize(isSelected: Bool) -> CGSize {
        return isSelected ? selectedAppearance.itemSize : normalAppearance.itemSize
    }
}
