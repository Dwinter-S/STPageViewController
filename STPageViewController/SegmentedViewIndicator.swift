//
//  SegmentedViewIndicator.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/15.
//

import UIKit

protocol SegmentedViewIndicator where Self: UIView {
    var size: CGSize { get set }
    var verticalOffset: CGFloat { get set }
}

class SegmentedViewLineIndicator: UIView, SegmentedViewIndicator {
    var size: CGSize
    var verticalOffset: CGFloat = 0
    init(size: CGSize, verticalOffset: CGFloat = 0) {
        self.size = size
        self.verticalOffset = verticalOffset
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.size = .zero
        super.init(coder: coder)
    }
}
