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
        case itemSpacingEqually
        case itemSpacingAndEdgeEqually
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private(set) var items: [SegmentedViewItemProtocol] = []
    private(set) var distribution: Distribution = .flowLayout
    private(set) var indicator: SegmentedViewIndicator?
    private(set) var selectedIndex: Int = 0
    private var itemNormalWidthPrefixSums: [CGFloat] = []
    private var useNormalSize = false
    private var redDotInfo = [SegmentedViewRedDot]()
    
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
    
    func reloadData(isUpdateIndicatorFrame: Bool = true) {
        setItemWidthPrefixSums()
        collectionView.reloadData()
        scrollItemToCenter(at: selectedIndex)
        if isUpdateIndicatorFrame {
            reloadIndicator(isIndicatorAnimated: false)
        }
    }
    
    func selectItem(at index: Int) {
        selectItem(at: index, isUpdateIndicatorFrame: true)
        if let scrollView = pageListScrollView {
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * CGFloat(index), y: 0), animated: true)
        }
    }
    
    private func selectItem(at index: Int, isUpdateIndicatorFrame: Bool) {
        guard index < items.count else { return }
        selectedIndex = index
        for i in (0..<items.count) {
            items[i].isSelected = false
        }
        items[index].isSelected = true
        reloadData(isUpdateIndicatorFrame: false)
        if isUpdateIndicatorFrame {
            reloadIndicator(isIndicatorAnimated: true)
        }
        delegate?.didSelectItem(at: index)
    }
    
    private func reloadIndicator(isIndicatorAnimated: Bool = false) {
        setIndicatorFrame(offsetPercent: CGFloat(selectedIndex), scrollDirection: nil, animated: isIndicatorAnimated)
    }
    
    func setIndicator(_ indicator: SegmentedViewIndicator) {
        self.indicator = indicator
        self.useNormalSize = true
        collectionView.addSubview(indicator)
    }
    
    deinit {
        pageListScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func config(items: [SegmentedViewItemProtocol], distribution: Distribution = .flowLayout, initialSelectedIndex: Int = 0) {
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
        for cellClass in cellClasses {
            collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
        }
        self.items = items
        self.distribution = distribution
        self.selectedIndex = initialSelectedIndex
        reloadData()
    }
    
    func configRedDotInfo(_ redDotInfo: [SegmentedViewRedDot]) {
        self.redDotInfo = redDotInfo
        reloadData()
    }
    
    func setRedDotsIfDisplay(_ redDotsStates: [Bool]) {
        for i in 0..<redDotsStates.prefix(redDotInfo.count).count {
            redDotInfo[i].display = redDotsStates[i]
        }
        reloadData()
    }
    
    func updateItems(_ items: [SegmentedViewItemProtocol]) {
        self.items = items
        if selectedIndex < items.count {
            self.items[selectedIndex].isSelected = true
        } else {
            self.items[0].isSelected = true
        }
        reloadData()
    }
    
    func updateItem(_ item: SegmentedViewItemProtocol, at index: Int) {
        guard items.count > index else { return }
        items[index] = item
        if index == selectedIndex {
            items[index].isSelected = true
        }
        reloadData()
    }
    
    func insertItem(_ newItem: SegmentedViewItemProtocol, at index: Int) {
        items.insert(newItem, at: index)
        reloadData()
    }
    
    func deleteItem(at index: Int) {
        guard items.count > index else { return }
        items.remove(at: index)
        reloadData()
    }
    
    private func commonInit() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func scrollItemToCenter(at index: Int) {
        guard index < items.count else { return }
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func sizeForItem(at index: Int, isSelected: Bool? = nil) -> CGSize {
        switch distribution {
        case .flowLayout, .itemSpacingEqually, .itemSpacingAndEdgeEqually:
            let itemModel = items[index]
//            let itemSize = useNormalSize ? itemModel.itemSize(isSelected: false) : itemModel.itemCurrentSize
            var itemSize = itemModel.itemCurrentSize
            if let isSelected = isSelected {
                itemSize = itemModel.itemSize(isSelected: isSelected)
            }
            return CGSize(width: itemSize.width, height: bounds.height)
        case .fillEqually:
            let contentSize = bounds.inset(by: contentEdgeInsets)
            let count = CGFloat(items.count)
            return CGSize(width: (contentSize.width - itemSpacing * (count - 1)) / count, height: contentSize.height)
        }
    }
    
    private func setIndicatorFrame(offsetPercent: CGFloat, scrollDirection: ScrollDirection?, animated: Bool) {
        guard let indicator = indicator else { return }
        let index = Int(offsetPercent)
        let maxCount = items.count
        if index >= 0, index < maxCount {
            let leftItemIndex = index
            let rightItemIndex = min(maxCount - 1, index + 1)
            let leftItemNormalWidth = sizeForItem(at: leftItemIndex, isSelected: false).width
            let leftItemSelectedWidth = sizeForItem(at: leftItemIndex, isSelected: true).width
            let rightItemSelectedWidth = sizeForItem(at: rightItemIndex, isSelected: true).width
            // 相邻两个item indicator之间的距离
            let distance = leftItemNormalWidth / 2 + realItemSpacing() + rightItemSelectedWidth / 2 - (leftItemSelectedWidth - leftItemNormalWidth) / 2
            
            let curPercent = offsetPercent - CGFloat(index)
            let indicatorCenterX = realContentEdgeInsets().left + itemNormalWidthPrefixSums[index] + leftItemSelectedWidth / 2 + distance * curPercent
            if animated {
                UIView.animate(withDuration: animated ? 0.25 : 0) {
                    indicator.frame.origin = CGPoint(x: indicatorCenterX - indicator.indicatorSize.width / 2, y: self.bounds.height - indicator.indicatorSize.height + indicator.verticalOffset)
                } completion: { _ in
                    
                }
            } else {
                indicator.frame.origin = CGPoint(x: indicatorCenterX - indicator.indicatorSize.width / 2, y: bounds.height - indicator.indicatorSize.height + indicator.verticalOffset)
            }
            indicator.frame.size = indicator.indicatorSize
        }
    }
    
    private func setItemWidthPrefixSums() {
        var itemNormalWidthPrefixSums: [CGFloat] = [0]
        var preSumWith: CGFloat = 0
        for index in 0..<items.count {
            preSumWith += sizeForItem(at: index).width + realItemSpacing()
            itemNormalWidthPrefixSums.append(preSumWith)
        }
        self.itemNormalWidthPrefixSums = itemNormalWidthPrefixSums
    }
    
    private func realItemSpacing() -> CGFloat {
        func itemsWidthSum() -> CGFloat {
            return items.reduce(0) { partialResult, item in
                return partialResult + item.itemCurrentSize.width
            }
        }
        switch distribution {
        case .flowLayout, .fillEqually:
            return itemSpacing
        case .itemSpacingEqually:
            let spaceSum = collectionView.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right - itemsWidthSum()
            return spaceSum / CGFloat(items.count - 1)
        case .itemSpacingAndEdgeEqually:
            let spaceSum = collectionView.bounds.width - itemsWidthSum()
            return spaceSum / CGFloat(items.count + 1)
        }
    }
    
    private func realContentEdgeInsets() -> UIEdgeInsets {
        if distribution == .itemSpacingAndEdgeEqually {
            let itemSpacing = realItemSpacing()
            return UIEdgeInsets(top: contentEdgeInsets.top, left: itemSpacing, bottom: contentEdgeInsets.bottom, right: itemSpacing)
        }
        return contentEdgeInsets
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }
    
}

extension SegmentedView {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let scrollView = object as? UIScrollView,
           keyPath == "contentOffset",
           scrollView.isTracking || scrollView.isDecelerating,
            let contentOffset = change?[.newKey] as? CGPoint {
            let preContentOffset = change?[.oldKey] as? CGPoint
            let offsetPercent = contentOffset.x / scrollView.bounds.size.width
            var scrollDirection: ScrollDirection?
            if let preContentOffset = preContentOffset {
                scrollDirection = preContentOffset.x > contentOffset.x ? .left : .right
            }
            setIndicatorFrame(offsetPercent: offsetPercent, scrollDirection: scrollDirection, animated: false)
            
            let index = Int(offsetPercent)
            let maxCount = items.count
            if index >= 0, index < maxCount {
                let curPercent = offsetPercent - CGFloat(index)
                var targetIndex: Int?
                switch scrollDirection {
                case .left where curPercent < 0.5: targetIndex = index
                case .right where curPercent > 0.5: targetIndex = index + 1
                default: ()
                }
                if let targetIndex = targetIndex, targetIndex != selectedIndex {
                    selectItem(at: targetIndex, isUpdateIndicatorFrame: false)
                }
            }
        }
    }
}

extension SegmentedView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemModel = items[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: itemModel.cellClass), for: indexPath) as? SegmentedViewBaseItemCell else {
            return UICollectionViewCell()
        }
        cell.setItemModel(itemModel)
        if indexPath.item < redDotInfo.count {
            cell.setRedDot(redDotInfo[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return realItemSpacing()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return realItemSpacing()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate?.shouldSelectItem(at: indexPath.item) ?? true else { return }
        if indexPath.item < items.count {
            selectItem(at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return realContentEdgeInsets()
    }
}
