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

    var collectionView: CollectionView!
    
    var currentPage: Dynamic<Int>?
    var itemSize: Dynamic<CGSize>?
    var cellIDs = [String]()
    var cells = [String : PlaceInfoCollectionViewCell]()
    let viewModel = PlaceDetailsViewModel()
    
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
        configureViews()
    }
    
    private func configureCollectionView() {
        collectionView = CollectionView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height), collectionViewLayout: UICollectionViewLayout())
            
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = false
        collectionView.clipsToBounds = true
        collectionView.isPagingEnabled = true
        
        for i in 0..<viewModel.pages.count {
            collectionView.register(viewModel.getCellClass(for: i), forCellWithReuseIdentifier: viewModel.pages[i].cellID)
        }
    }
    
    private func configureViews() {
        constrain(collectionView, self.contentView) { collection, view in
            collection.left == view.left
            collection.right == view.right
            collection.top == view.top
            collection.bottom == view.bottom
        }
    }
    
    private func bindDynamics() {
        currentPage?.bind({ [weak self] (index) in
            let indexPath = IndexPath(row: index, section: 0)
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self?.reloadCell(at: indexPath)
        })
        itemSize?.bind({ [weak self] (size) in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    private func reloadCell(at indexPath: IndexPath) {
        let cellID = viewModel.pages[indexPath.row].cellID
        
        if let cell = viewModel.cells[cellID] {
            cell.reload()
        }
    }
    
    func configure(with currentPage: Dynamic<Int>) {
        self.currentPage = currentPage
        
        setCollectionViewLayout()
        bindDynamics()
    }
}

extension PlaceDetailsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        itemSize = Dynamic(CGSize(width: collectionView.frame.width, height: collectionView.frame.height))
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.itemSize?.value.width ?? collectionView.frame.width, height: self.itemSize?.value.height ?? collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.pages[indexPath.row].cellID, for: indexPath) as! PlaceDetailCollectionCell
        
        viewModel.cells[viewModel.pages[indexPath.row].cellID] = cell
        
        switch viewModel.pages[indexPath.row] {
        case .info:
            (cell as! PlaceInfoCollectionViewCell).configure(itemSize: self.itemSize)
        case .events:
            (cell as! PlaceEventsCollectionViewCell).configure(itemSize: self.itemSize)
        case .menu:
            (cell as! PlaceMenuCollectionViewCell).configure(itemSize: self.itemSize)
        case .reviews:
            (cell as! PlaceReviewsCollectionViewCell).configure(itemSize: self.itemSize)
        }
        
        if indexPath.row == currentPage?.value {
            cell.reload()
        }

        return cell
    }
}
