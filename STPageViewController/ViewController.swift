//
//  ViewController.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

class ViewController: UIViewController {

    var segmentedView: SegmentedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["全部", "人物", "事物", "事件", "地点"]
        var items = [SegmentedViewTextImageItemModel]()
        for title in titles {
            var item = SegmentedViewTextImageItemModel()
            item.cellClass = SegmentedViewTextImageItemCell.self
            var normalAppearance = SegmentedTextImageItemAppearance(
                font: .systemFont(ofSize: 14, weight: .medium),
                textColor: .gray)
            
            item.normalAppearance = normalAppearance
            var selectedAppearance = SegmentedTextImageItemAppearance(
                font: .systemFont(ofSize: 14, weight: .medium),
                textColor: .white)
            selectedAppearance.backgroundColor = .blue
            selectedAppearance.cornerRadius = 10
            item.selectedAppearance = selectedAppearance
            item.title = title
            items.append(item)
        }
        
        segmentedView = SegmentedView(items: items, distribution: .flowLayout, initialSelectedIndex: 1)
        segmentedView.itemSpacing = 10
        view.addSubview(segmentedView)
        segmentedView.backgroundColor = .cyan
        segmentedView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(30)
        }
    }


}

