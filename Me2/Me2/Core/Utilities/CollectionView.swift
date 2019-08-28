//
//  CollectionView.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/23/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class CollectionView : UICollectionView {
    private var reloadDataCompletionBlock: (() -> Void)?
    private var invalidateLayoutCompletionBlock: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
//        invalidateLayoutCompletionBlock?()
    }
    
    func reloadDataWithCompletion(completion: @escaping VoidBlock) {
        reloadDataCompletionBlock = completion
        self.reloadData()
    }
    
    func invalidateLayoutWithCompletion(completion: @escaping VoidBlock) {
        invalidateLayoutCompletionBlock = completion
        self.collectionViewLayout.invalidateLayout()
    }
}
