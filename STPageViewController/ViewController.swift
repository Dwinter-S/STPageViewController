//
//  ViewController.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

class ViewController: PageListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["全部", "人物", "事物", "事件", "地点"]
        var items = [SegmentedViewTextImageItemModel]()
        for title in titles {
            let normalAppearance = SegmentedTextImageItemAppearance(text: title,
                                                                     font: .systemFont(ofSize: 14, weight: .medium),
                                                                     textColor: .gray
//                                                                    baseAppearance: SegmentedViewItemBaseAppearance(backgroundColor: .yellow, cornerRadius: 10)
            )
            
            let selectedAppearance = SegmentedTextImageItemAppearance(text: title,
                                                                      font: .systemFont(ofSize: 30, weight: .medium),
                                                                      textColor: .black
//                                                                      baseAppearance: SegmentedViewItemBaseAppearance(backgroundColor: .blue, cornerRadius: 10)
            )
            
            let item = SegmentedViewTextImageItemModel(normalAppearance: normalAppearance, selectedAppearance: selectedAppearance)
            
            items.append(item)
        }
        
        
        let initialSelectedIndex = 1
        configSegmentedView(items: items, distribution: .itemSpacingAndEdgeEqually, itemSpacing: 30, initialSelectedIndex: initialSelectedIndex, indicator: defaultLineIndicator)
        view.addSubview(segmentedView)
        segmentedView.backgroundColor = .cyan
        segmentedView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints {
            $0.top.equalTo(segmentedView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        listContainerView.loadPageStrategy = .scrollPercent(0.8)
        
        var pages = [PageProducer]()
        for _ in titles {
            pages.append({
                let vc = UIViewController()
                vc.view.backgroundColor = UIColor.randomColor
                return vc
            })
        }
        
        config(withPageProducers: pages, initialPageIndex: initialSelectedIndex)
    }


}


extension UIColor {
    //返回随机颜色
    open class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
