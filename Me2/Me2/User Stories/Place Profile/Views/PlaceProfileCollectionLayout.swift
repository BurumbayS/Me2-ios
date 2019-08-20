//
//  PlaceProfileColelctionLayout.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlaceProfileCollectionLayout: UICollectionViewFlowLayout {
    //set original header height manually
    let headerHeight: CGFloat = 300
    
    override init() {
        super.init()
        
        self.sectionHeadersPinToVisibleBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach({ (attribute) in
            
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                guard let collectionView = collectionView else { return }
                
                let contentOffsetY = collectionView.contentOffset.y
                print(contentOffsetY)
                
                if contentOffsetY > 0 { return }
                
                let width = collectionView.frame.width
                let height = attribute.frame.height - contentOffsetY
                
                attribute.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
            } else {
//                guard let collectionView = collectionView else { return }
//                
//                let contentOffsetY = collectionView.contentOffset.y
//                
//                if contentOffsetY < 0 { return }
//                
//                let width = collectionView.frame.width
//                let height = collectionView.frame.height - self.headerHeight + contentOffsetY
//                
//                attribute.frame = CGRect(x: 0, y: self.headerHeight, width: width, height: height)
//                
//                collectionView.frame = CGRect(x: 0, y: 0, width: width, height: height + self.headerHeight)
            }
            
        })
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
