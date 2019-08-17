//
//  PlaceProfileColelctionLayout.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlaceProfileCollectionLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach({ (attribute) in
            
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else { return }
                
                let contentOffsetY = collectionView.contentOffset.y
                let width = collectionView.frame.width
                let height = (contentOffsetY < 0) ? attribute.frame.height - contentOffsetY : attribute.frame.height
                
                attribute.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
            }
            
        })
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
