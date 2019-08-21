//
//  PlaceDetailsCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceDetailsCollectionViewCell: UICollectionViewCell {

    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionView()
        setCollectionViewLayout()
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.contentView.addSubview(collectionView)
        constrain(collectionView, self.contentView) { collection, view in
            collection.left == view.left
            collection.right == view.right
            collection.top == view.top
            collection.bottom == view.bottom
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height), collectionViewLayout: UICollectionViewLayout())
            
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.clipsToBounds = true
        collectionView.isPagingEnabled = true
        
        collectionView.register(PlaceInfoCollectionViewCell.self)
    }
}

extension PlaceDetailsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize =  CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlaceInfoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        return cell
    }
}
