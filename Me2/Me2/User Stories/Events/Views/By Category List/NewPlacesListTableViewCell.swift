//
//  NewPlacesListTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class NewPlacesListTableViewCell: UITableViewCell {
    
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewLayout())
    
    var viewModel: NewPlacesViewModel!
    
    var presenterDelegate: ControllerPresenterDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
        configureCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: NewPlacesViewModel, presenterDelegate: ControllerPresenterDelegate) {
        self.viewModel = viewModel
        self.presenterDelegate = presenterDelegate
        
        fetchData()
    }
    
    private func fetchData() {
        viewModel.fetchData { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.collectionView.reloadData()
            case .error:
                break
            case .fail:
                break
            }
        }
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
            collection.height == 150
        }
    }

}

extension NewPlacesListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 105, height: 150)
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel != nil { return viewModel.places.count } else { return 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell: NewPlaceCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.configure(place: viewModel.places[indexPath.row])
        
        return cell
        
    }
}
