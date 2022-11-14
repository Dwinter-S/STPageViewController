//
//  SegmentedView.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

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
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private var items: [SegmentedViewItemProtocol]
    private var distribution: Distribution
    private var cellClasses: [UICollectionViewCell.Type] = [UICollectionViewCell.self]
    private(set) var selectedIndex: Int = 0
    var itemSpacing: CGFloat = 10
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    init<T: SegmentedViewItemProtocol>(items: [T], distribution: Distribution = .flowLayout, initialSelectedIndex: Int = 0) {
        var items = items
        if items.count > initialSelectedIndex {
            items[initialSelectedIndex].isSelected = true
            print("?????\(items[initialSelectedIndex].isSelected)")
        }
        self.items = items
        self.distribution = distribution
        var cellClasses = [UICollectionViewCell.Type]()
        for item in items {
            if !cellClasses.contains(where: {$0 == item.cellClass}) {
                cellClasses.append(item.cellClass)
            }
        }
        self.cellClasses = cellClasses
        self.selectedIndex = initialSelectedIndex
        super.init(frame: .zero)
        commonInit()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
        scrollCurrentItemToCenter()
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
        switch distribution {
        case .flowLayout:
            let itemModel = items[indexPath.item]
            return CGSize(width: itemModel.itemSize.width, height: collectionView.bounds.height)
        case .fillEqually:
            let count = CGFloat(items.count)
            return CGSize(width: (collectionView.bounds.width - itemSpacing * (count - 1)) / count, height: collectionView.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < items.count {
            for i in (0..<items.count) {
                items[i].isSelected = false
            }
            items[indexPath.item].isSelected = true
            selectedIndex = indexPath.item
            collectionView.reloadData()
            scrollCurrentItemToCenter()
        }
    }
}
