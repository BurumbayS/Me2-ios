//
//  FavouritePlacesTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class FavouritePlacesTableViewCell: UITableViewCell {
    
    let addPlacesButton = UIButton()
    var collectionView: UICollectionView!
    let placeHolderLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
        configureCollectionView()
        setCollectionViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: Int, profileType: ProfileType) {
        switch profileType {
        case .myProfile:
            placeHolderLabel.isHidden = true
        default:
            addPlacesButton.isHidden = true
        }
        
        if data > 0 {
            collectionView.isHidden = false
        } else {
            collectionView.isHidden = true
        }
    }
    
    private func setUpViews() {
        addPlacesButton.setTitleColor(Color.red, for: .normal)
        addPlacesButton.setTitle("+ Добавить любимое место", for: .normal)
        addPlacesButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        
        self.contentView.addSubview(addPlacesButton)
        constrain(addPlacesButton, self.contentView) { btn, view in
            btn.centerX == view.centerX
            btn.centerY == view.centerY
            btn.height == 20
        }
        
        placeHolderLabel.textColor = .darkGray
        placeHolderLabel.text = "Любимых мест пока нет"
        placeHolderLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(placeHolderLabel)
        constrain(placeHolderLabel, self.contentView) { label, view in
            label.centerX == view.centerX
            label.centerY == view.centerY
            label.height == 20
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.isHidden = true
        self.contentView.addSubview(collectionView)
        constrain(collectionView, self.contentView) { collection, view in
            collection.left == view.left
            collection.top == view.top
            collection.right == view.right
            collection.bottom == view.bottom
            collection.height == 90
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FavouritePlaceCollectionViewCell.self)
    }
}

extension FavouritePlacesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 90)
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavouritePlaceCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        if indexPath.row % 2 == 0 {
            cell.configure(with: UIImage(named: "sample_place_logo")!, and: "Мята")
        } else {
            cell.configure(with: UIImage(named: "sample_place_logo")!, and: "Traveler's Coffee")
        }
        return cell
    }
}
