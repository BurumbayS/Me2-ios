//
//  PlaceOptionalsTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceOptionalsTableViewCell: UITableViewCell {
    var collectionView: CollectionView!
    var collectionViewConstraints = ConstraintGroup()
    
    let optionals = ["Средний чек 3000тг","Заказ на вынос","Бизнес-ланч","Терраса"]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
        setCollectionViewLayout()
        configureCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        collectionView = CollectionView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height), collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .white
        self.contentView.addSubview(collectionView)
        constrain(collectionView, self.contentView, replace: collectionViewConstraints) { collection, view in
            collection.top == view.top + 15
            collection.bottom == view.bottom - 15
            collection.left == view.left + 15
            collection.right == view.right - 15
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PlaceOptionalCollectionViewCell.self)
    }
}

extension PlaceOptionalsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = optionals[indexPath.row].getWidth(with: UIFont(name: "Roboto-Regular", size: 11)!) + 20
        return CGSize(width: width, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlaceOptionalCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.configure(with: optionals[indexPath.row])
        
        return cell
    }
}
