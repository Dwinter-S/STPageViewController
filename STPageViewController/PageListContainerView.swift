//
//  PageListContainerView.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit
import SnapKit

protocol PageListDataSource: AnyObject {
    func numberOfPages(in pageListView: PageListContainerView) -> Int
    func pageView(at index: Int, in pageListView: PageListContainerView) -> UIView
}

@objc protocol PageListDelegate {
    @objc optional func pageListScrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func pageListScrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func pageListScrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    @objc optional func pageListScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func pageListScrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func pageListScrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func pageListScrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    @objc optional func didScrollToPageView(at index: Int)
}

class PageListContainerView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        sv.bounces = false
        return sv
    }()
    private let pagesContentView = UIView()
//    private var selectedView: UIView?
    private var pagesCount: Int = 0
    /// 初始选中页下标
    private var initialPageIndex: Int = 0
    /// 当前选中页下标
    private(set) var currentPageIndex: Int = 0
    /// 已经加载的视图
    private(set) var loadedPages = [Int : UIView]()
    
    weak var dataSource: PageListDataSource?
    weak var delegate: PageListDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        scrollView.addSubview(pagesContentView)
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            reloadData()
        }
    }
    
    func setInitialPageIndex(_ index: Int) {
        initialPageIndex = index
        guard loadedPages.values.count == 0 else { return }
        currentPageIndex = index
    }
    
    func scrollToPage(at index: Int, animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * CGFloat(index), y: 0), animated: animated)
        if !animated {
            didScrollToPageView(at: index)
        }
    }
    
    func reloadData() {
        guard let dataSource = dataSource else { return }
        pagesCount = dataSource.numberOfPages(in: self)
        pagesContentView.snp.remakeConstraints {
            $0.edges.height.equalToSuperview()
            $0.width.equalTo(scrollView).multipliedBy(pagesCount > 0 ? pagesCount : 1)
        }
        loadedPages.values.forEach({
            $0.removeFromSuperview()
        })
        loadedPages.removeAll()
        if currentPageIndex >= pagesCount {
            currentPageIndex = initialPageIndex
        }
        loadPageView(at: currentPageIndex)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * CGFloat(currentPageIndex), y: 0), animated: false)
    }
    
    private func loadPageView(at index: Int) {
        guard pagesCount > index, let pageView = dataSource?.pageView(at: index, in: self) else {
            return
        }
        pagesContentView.addSubview(pageView)
        loadedPages[index] = pageView
        pageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(scrollView)
            if index == 0 {
                $0.left.equalToSuperview()
            } else {
                $0.left.equalTo(pagesContentView.snp.right).multipliedBy(CGFloat(index) / CGFloat(self.pagesCount))
            }
        }
    }
    private func didScrollToPageView(at index: Int) {
        if loadedPages[index] == nil {
            loadPageView(at: index)
        }
        currentPageIndex = index
        delegate?.didScrollToPageView?(at: index)
    }

}


extension PageListContainerView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        didScrollToPageView(at: index)
        
        delegate?.pageListScrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.pageListScrollViewDidScroll?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.pageListScrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.pageListScrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.pageListScrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.pageListScrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        didScrollToPageView(at: index)
        delegate?.pageListScrollViewDidEndScrollingAnimation?(scrollView)
    }
}
