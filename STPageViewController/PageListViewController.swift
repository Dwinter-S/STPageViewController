//
//  PageListViewController.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

typealias PageProducer = (() -> UIViewController)

class PageListViewController: UIViewController, PageListDelegate {
    var pageProducers = [PageProducer]()
    let listContainerView = PageListContainerView()
    lazy var segmentedView = SegmentedView()
    
    lazy var defaultLineIndicator: SegmentedViewLineIndicator = {
        let indicator = SegmentedViewLineIndicator(size: CGSize(width: 16, height: 2))
        indicator.verticalOffset = 0
        indicator.backgroundColor = .blue
        indicator.layer.cornerRadius = 1
        return indicator
    }()
    
    var selectedVC: UIViewController? {
        return loadedVCs[segmentedView.selectedIndex]
    }
    
    var loadedVCs: [Int : UIViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        listContainerView.dataSource = self
        listContainerView.delegate = self
    }
    
    func configSegmentedView(items: [SegmentedViewItemProtocol],
                             distribution: SegmentedView.Distribution,
                             itemSpacing: CGFloat = 0,
                             contentEdgeInsets: UIEdgeInsets = .zero,
                             initialSelectedIndex: Int = 0,
                             indicator: SegmentedViewIndicator? = nil) {
        segmentedView.delegate = self
        segmentedView.itemSpacing = itemSpacing
        segmentedView.contentEdgeInsets = contentEdgeInsets
        segmentedView.pageListScrollView = listContainerView.scrollView
        if let indicator = indicator {
            segmentedView.setIndicator(indicator)
        }
        segmentedView.config(items: items, distribution: distribution, initialSelectedIndex: initialSelectedIndex)
    }
    
    func configSegmentedView(titles: [String],
                             distribution: SegmentedView.Distribution = .itemSpacingAndEdgeEqually,
                             itemSpacing: CGFloat = 0,
                             contentEdgeInsets: UIEdgeInsets = .zero,
                             initialPageIndex: Int = 0) {
        var items = [SegmentedViewTextImageItemModel]()
        for title in titles {
            let normalAppearance = SegmentedTextImageItemAppearance(text: title,
                                                                    font: .systemFont(ofSize: 16),
                                                                    textColor: .gray)
            let selectedAppearance = SegmentedTextImageItemAppearance(text: title,
                                                                      font: .systemFont(ofSize: 16),
                                                                      textColor: .black)
            let item = SegmentedViewTextImageItemModel(normalAppearance: normalAppearance, selectedAppearance: selectedAppearance)
            items.append(item)
        }
        configSegmentedView(items: items,
                            distribution: distribution,
                            itemSpacing: itemSpacing,
                            contentEdgeInsets: contentEdgeInsets,
                            initialSelectedIndex: initialPageIndex,
                            indicator: defaultLineIndicator)
    }
    
    func config(withPageProducers pageProducers: [PageProducer],
                initialPageIndex: Int = 0) {
        self.pageProducers = pageProducers
        listContainerView.setInitialPageIndex(initialPageIndex)
        listContainerView.reloadData()
    }
    
    func scrollToPage(at index: Int) {
        guard index < pageProducers.count else { return }
        segmentedView.selectItem(at: index)
        listContainerView.scrollToPage(at: index, animated: true)
    }
    func didSelectedItem(at index: Int) {}
}

extension PageListViewController: SegmentedViewDelegate {
    func didSelectItem(at index: Int) {
        didSelectedItem(at: index)
    }
}

extension PageListViewController: PageListDataSource {
    func numberOfPages(in pageView: PageListContainerView) -> Int {
        return pageProducers.count
    }
    
    func pageView(at index: Int, in pageView: PageListContainerView) -> UIView {
        let vc = pageProducers[index]()
        addChild(vc)
        loadedVCs[index] = vc
        return vc.view
    }
}
