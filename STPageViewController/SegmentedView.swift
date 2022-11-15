//
//  SegmentedView.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

protocol SegmentedViewDelegate: AnyObject {
    func didSelectItem(at index: Int)
    func shouldSelectItem(at index: Int) -> Bool
}

extension SegmentedViewDelegate {
    func shouldSelectItem(at index: Int) -> Bool {
        return true
    }
}

enum ScrollDirection {
    case up
    case down
    case left
    case right
}

class SegmentedView: UIView {
    
    enum Distribution {
        case flowLayout
        case fillEqually
//        case equalSpacing
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.showsHorizontalScrollIndicator = false
        cv.contentInsetAdjustmentBehavior = .never
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private var items: [SegmentedViewItemProtocol]
    private var distribution: Distribution
    private var cellClasses: [UICollectionViewCell.Type] = [UICollectionViewCell.self]
    private var indicator: SegmentedViewIndicator?
    private(set) var selectedIndex: Int = 0
    private var itemNormalWidthPrefixSums: [CGFloat] = []
    
    weak var delegate: SegmentedViewDelegate?
    
    /// item间距
    var itemSpacing: CGFloat = 10
    var contentEdgeInsets: UIEdgeInsets = .zero
    var pageListScrollView: UIScrollView? {
        willSet {
            pageListScrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
        didSet {
            pageListScrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.old, .new], context: nil)
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
        scrollCurrentItemToCenter()
        setItemWidthPrefixSums()
    }
    
    func selectItem(at index: Int) {
        guard index < items.count else { return }
        selectedIndex = index
        for i in (0..<items.count) {
            items[i].isSelected = false
        }
        items[index].isSelected = true
        reloadData()
    }
    
    func setIndicator(_ indicator: SegmentedViewIndicator) {
        self.indicator = indicator
        collectionView.addSubview(indicator)
    }
    
    deinit {
        pageListScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    init(items: [SegmentedViewItemProtocol], distribution: Distribution = .flowLayout, initialSelectedIndex: Int = 0) {
        var items = items
        if items.count > initialSelectedIndex {
            items[initialSelectedIndex].isSelected = true
        }
        var cellClasses = [UICollectionViewCell.Type]()
        for item in items {
            if !cellClasses.contains(where: {$0 == item.cellClass}) {
                cellClasses.append(item.cellClass)
            }
        }
        self.items = items
        self.distribution = distribution
        self.cellClasses = cellClasses
        self.selectedIndex = initialSelectedIndex
        super.init(frame: .zero)
        commonInit()
        setItemWidthPrefixSums()
    }
    
    required init?(coder: NSCoder) {
        items = []
        distribution = .flowLayout
        super.init(coder: coder)
    }
    
    private func commonInit() {
        for cellClass in cellClasses {
            collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
        }
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func scrollCurrentItemToCenter() {
        collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func sizeForItem(at index: Int, isSelected: Bool? = nil) -> CGSize {
        switch distribution {
        case .flowLayout:
            let itemModel = items[index]
            var itemSize: CGSize
            if let isSelected = isSelected {
                itemSize = itemModel.itemSize(isSelected: isSelected)
            } else {
                itemSize = itemModel.itemSize
            }
            return CGSize(width: itemSize.width, height: bounds.height)
        case .fillEqually:
            let contentSize = bounds.inset(by: contentEdgeInsets)
            let count = CGFloat(items.count)
            return CGSize(width: (contentSize.width - itemSpacing * (count - 1)) / count, height: contentSize.height)
        }
    }
    
    private func setIndicatorFrame(offsetPercent: CGFloat, scrollDirection: ScrollDirection?) {
        guard let indicator = indicator else { return }
        let index = Int(offsetPercent)
        let maxCount = items.count
        if index >= 0, index < maxCount {
            let curPercent = offsetPercent - CGFloat(index)
            let isSelectLeft = curPercent < 0.5
            var targetIndex: Int?
            switch scrollDirection {
            case .left where curPercent < 0.5: targetIndex = index
            case .right where curPercent > 0.5: targetIndex = index + 1
            default: ()
            }
            if let targetIndex = targetIndex, targetIndex != selectedIndex {
                selectItem(at: targetIndex)
            }
            let leftItemSize = sizeForItem(at: index, isSelected: isSelectLeft)
            let rightItemSize = sizeForItem(at: min(maxCount - 1, index + 1), isSelected: !isSelectLeft)
            let distance = leftItemSize.width / 2 + itemSpacing + rightItemSize.width / 2
            let indicatorCenterX = contentEdgeInsets.left + itemNormalWidthPrefixSums[index] + leftItemSize.width / 2 + distance * curPercent
            indicator.frame.origin = CGPoint(x: indicatorCenterX - indicator.size.width / 2, y: bounds.height - indicator.size.height + indicator.verticalOffset)
            indicator.frame.size = indicator.size
            print("?????\(indicator.frame)")
        }
    }
    
    private func setItemWidthPrefixSums() {
        var itemNormalWidthPrefixSums: [CGFloat] = [0]
        var preSumWith: CGFloat = 0
        for index in 0..<items.count {
            preSumWith += sizeForItem(at: index, isSelected: false).width + itemSpacing
            itemNormalWidthPrefixSums.append(preSumWith)
        }
//        print("????\(itemNormalWidthPrefixSums)")
        self.itemNormalWidthPrefixSums = itemNormalWidthPrefixSums
    }
    
//    private func setCellCenterXs() {
//        var cellCenterXs = [CGFloat]()
//        var startX = contentEdgeInsets.left
//        for index in (0..<items.count) {
//            let size = sizeForItem(at: index)
//            cellCenterXs.append(startX + size.width / 2)
//            startX += size.width + itemSpacing
//        }
//        self.cellCenterXs = cellCenterXs
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
        setIndicatorFrame(offsetPercent: CGFloat(selectedIndex), scrollDirection: nil)
    }
    
}

extension SegmentedView {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let scrollView = object as? UIScrollView, keyPath == "contentOffset", let contentOffset = change?[.newKey] as? CGPoint {
            let preContentOffset = change?[.oldKey] as? CGPoint
            let offsetPercent = contentOffset.x / scrollView.bounds.size.width
            var scrollDirection: ScrollDirection?
            if let preContentOffset = preContentOffset {
                scrollDirection = preContentOffset.x > contentOffset.x ? .left : .right
            }
            setIndicatorFrame(offsetPercent: offsetPercent, scrollDirection: scrollDirection)
        }
    }
}

extension SegmentedView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemModel = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: itemModel.cellClass), for: indexPath) as! SegmentedViewBaseItemCell
        cell.setItemModel(itemModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate?.shouldSelectItem(at: indexPath.item) ?? true else { return }
        if indexPath.item < items.count {
            selectItem(at: indexPath.item)
            delegate?.didSelectItem(at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return contentEdgeInsets
    }
}
