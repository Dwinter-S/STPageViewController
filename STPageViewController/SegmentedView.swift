//
//  SegmentedView.swift
//  Test
//
//  Created by Mac mini on 2022/11/11.
//

import UIKit

class SegmentedView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView()
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private var items: [SegmentedViewItemModel] = []
    private var cellClasses: [UICollectionViewCell.Type] = [SegmentedViewItemCell.self]
    
    var itemSpacing: CGFloat = 10
    
    init(items: [SegmentedViewItemModel], cellClasses: [UICollectionViewCell.Type]) {
        self.items = items
        self.cellClasses = cellClasses
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
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

}

extension SegmentedView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemModel = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: itemModel.cellClass), for: indexPath) as! SegmentedViewItemCell
        cell.setItemModel(itemModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemModel = items[indexPath.item]
        return CGSize(width: itemModel.itemWidth, height: collectionView.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
