//
//  EventsListTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EventsListTableViewCell: UITableViewCell {
    
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewLayout())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
        configureCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.registerNib(EventCollectionViewCell.self)
        collectionView.registerNib(NewPlaceCollectionViewCell.self)
        
        setCollectionViewLayout()
    }
    
    private func setUpViews() {
        self.contentView.addSubview(collectionView)
        constrain(collectionView, self.contentView) { collection, view in
            collection.top == view.top + 10
            collection.left == view.left
            collection.right == view.right
            collection.bottom == view.bottom - 20
            collection.height == 216
        }
    }
}

extension EventsListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 277, height: 216)
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        let event = Event()
        event.title = "20% скидка на все кальяны! "
        event.location = "Мята Бар"
        event.time = "Ежедневно 20:00-00:00"
        event.eventType = "Акция"
        
        cell.configure(wtih: event)
        
        return cell
    }
}
