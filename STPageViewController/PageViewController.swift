//
//  PageListViewController.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

typealias PageProducer = (() -> UIViewController)

class PageListViewController: UIViewController {
    var pageProducers = [PageProducer]()
    let pageView = PageListContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.dataSource = self
    }
    
    func config(withPageProducers pageProducers: [PageProducer],
                initialPageIndex: Int = 0) {
        self.pageProducers = pageProducers
        pageView.setInitialPageIndex(initialPageIndex)
        pageView.reloadData()
    }
    
    func scrollToPage(at index: Int) {
        
    }

}

extension PageListViewController: PageListDataSource {
    func numberOfPages(in pageView: PageListContainerView) -> Int {
        return pageProducers.count
    }
    
    func pageView(at index: Int, in pageView: PageListContainerView) -> UIView {
        return pageProducers[index]().view
    }
}

