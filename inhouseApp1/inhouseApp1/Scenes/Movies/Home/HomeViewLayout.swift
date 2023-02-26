//
//  HomeViewLayout.swift
//  inhouseApp1
//
//  Created by alejandro on 29/08/22.
//

import UIKit

class HomeViewLayout: UICollectionViewLayout {
    let numberOfSection = 0
    var contentHeight: CGFloat = 0
    var minimunCellSpace: CGFloat = 0
    var attributesArray: [UICollectionViewLayoutAttributes] = []
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        return CGSize(width: collectionView.bounds.width, height: contentHeight)
    }

    override
    func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        contentHeight = 0
        let width = collectionView.bounds.width
        let dataSource = collectionView.dataSource
        let itemsCount = dataSource?.collectionView(collectionView,
                                                    numberOfItemsInSection: numberOfSection) ?? 0
        attributesArray = []
        let cell = HomeCell().homeCellInstance()
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: numberOfSection)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.alpha = 1.0
            attribute.isHidden = false
            cell?.prepareForReuse()
            if let cellSize = cell?.systemLayoutSizeFitting(CGSize(width: width, height: CGFloat.infinity)) {
                contentHeight = cellSize.height + minimunCellSpace + contentHeight
                let ySize = contentHeight - cellSize.height
                attribute.frame = CGRect(x: 0.0, y: ySize , width: width, height: cellSize.height)
            }
            attributesArray.append(attribute)
        }
    }
    override
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes: [UICollectionViewLayoutAttributes] = attributesArray.compactMap {
            $0.frame.intersects(rect) ? $0 : nil
        }
        return layoutAttributes
    }
    override
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesArray.first { $0.indexPath == indexPath }
    }
    override
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
