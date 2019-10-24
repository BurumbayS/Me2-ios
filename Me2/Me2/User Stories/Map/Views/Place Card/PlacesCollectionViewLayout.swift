//
//  PlacesCollectionViewLayout.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/14/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlacesCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var previousOffset: CGFloat = 0
    var currentPage: Dynamic<Int>!
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        // Imitating paging behaviour
        // Check previous offset and scroll direction
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
            currentPage.value = max(currentPage.value - 1, 0)
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
            currentPage.value = min(currentPage.value + 1, itemsCount - 1)
        }
        
        // Update offset by using item size + spacing
        let itemEdgeOffset:CGFloat = (collectionView.frame.width - itemSize.width -  minimumLineSpacing * 2) / 2
        let updatedOffset: CGFloat = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage.value) - (itemEdgeOffset) + (sectionInset.left - minimumLineSpacing)
        previousOffset = updatedOffset
        
        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }
}
