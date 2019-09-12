//
//  PlaceProfileColelctionLayout.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlaceProfileCollectionLayout: UICollectionViewFlowLayout {

    var topBarHeight: CGFloat = 0
    
    func configure (with distanceToTop: CGFloat) {
        topBarHeight = distanceToTop
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach({ (attribute) in
            if attribute.indexPath == IndexPath(row: 0, section: 0) {
                guard let collectionView = collectionView else { return }
                
                let contentOffsetY = collectionView.contentOffset.y

                if contentOffsetY > 0 {
                    attribute.frame = CGRect(x: 0, y: -topBarHeight, width: attribute.frame.width, height: attribute.frame.height + topBarHeight)
                } else {
                    let width = collectionView.frame.width
                    let height = attribute.frame.height - contentOffsetY

                    attribute.frame = CGRect(x: 0, y: contentOffsetY - topBarHeight, width: width, height: height + topBarHeight)
                }
            }
            
        })
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func turnPinToVisibleBounds() {
        self.sectionHeadersPinToVisibleBounds = true
    }
    func offPinToVisibleBounds() {
        self.sectionHeadersPinToVisibleBounds = false
    }
}
