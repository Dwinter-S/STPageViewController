//
//  SegmentedViewIndicator.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/15.
//

import UIKit

protocol SegmentedViewIndicator where Self: UIView {
    var indicatorSize: CGSize { get set }
    var verticalOffset: CGFloat { get set }
}

class SegmentedViewLineIndicator: UIView, SegmentedViewIndicator {
    var indicatorSize: CGSize
    var verticalOffset: CGFloat = 0
    init(size: CGSize, verticalOffset: CGFloat = 0) {
        self.indicatorSize = size
        self.verticalOffset = verticalOffset
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.indicatorSize = .zero
        super.init(coder: coder)
    }
}
