//
//  ViewController.swift
//  STPageViewController
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

class ViewController: PageListViewController {

    var segmentedView: SegmentedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["全部", "人物", "事物", "事件", "地点", "全部", "人物", "事物", "事件", "地点"]
        var items = [SegmentedViewTextImageItemModel]()
        for title in titles {
            let normalAppearance = SegmentedTextImageItemAppearance(title: title,
                                                                     font: .systemFont(ofSize: 14, weight: .medium),
                                                                     textColor: .gray
//                                                                    baseAppearance: SegmentedViewItemBaseAppearance(backgroundColor: .yellow, cornerRadius: 10)
            )
            
            let selectedAppearance = SegmentedTextImageItemAppearance(title: title,
                                                                      font: .systemFont(ofSize: 30, weight: .medium),
                                                                      textColor: .black
//                                                                      baseAppearance: SegmentedViewItemBaseAppearance(backgroundColor: .blue, cornerRadius: 10)
            )
            
            let item = SegmentedViewTextImageItemModel(normalAppearance: normalAppearance, selectedAppearance: selectedAppearance)
            
            items.append(item)
        }
        let initialSelectedIndex = 1
        segmentedView = SegmentedView(items: items, distribution: .flowLayout, initialSelectedIndex: initialSelectedIndex)
        segmentedView.delegate = self
        segmentedView.itemSpacing = 30
        segmentedView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        segmentedView.pageListScrollView = pageView.scrollView
        let indicator = SegmentedViewLineIndicator(size: CGSize(width: 26, height: 3))
        indicator.verticalOffset = -5
        indicator.backgroundColor = .blue
        indicator.layer.cornerRadius = 1.5
        segmentedView.setIndicator(indicator)
        view.addSubview(segmentedView)
        segmentedView.backgroundColor = .cyan
        segmentedView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        pageView.delegate = self
        view.addSubview(pageView)
        pageView.snp.makeConstraints {
            $0.top.equalTo(segmentedView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
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

extension ViewController: SegmentedViewDelegate {
    func didSelectItem(at index: Int) {
        pageView.scrollToPage(at: index, animated: true)
    }
}

extension ViewController: PageListDelegate {
    func didScrollToPageView(at index: Int) {
        segmentedView.selectItem(at: index)
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
