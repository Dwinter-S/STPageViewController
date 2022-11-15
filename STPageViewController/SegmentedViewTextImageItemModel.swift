//
//  SegmentedViewTextImageItemModel.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/14.
//

import UIKit

struct SegmentedViewTextImageItemModel: SegmentedViewItemProtocol {
    let cellClass: UICollectionViewCell.Type = SegmentedViewTextImageItemCell.self
    var normalAppearance: SegmentedViewItemAppearance
    var selectedAppearance: SegmentedViewItemAppearance
    var isSelected: Bool = false
}
