//
//  PlaceDetailsCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cosmos

class PlaceDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var liveChatButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
        configureCollectionView()
    }

    private func configureViews() {
        liveChatButton.tintColor = Color.blue
        liveChatButton.layer.cornerRadius = 5
        liveChatButton.layer.borderColor = Color.blue.cgColor
        liveChatButton.layer.borderWidth = 2.0
        segmentedControl.configure(for: ["Инфо","События","Меню","Отзывы"], with: UIScreen.main.bounds.width)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PlaceInfoCollectionViewCell.self)
    }
}

extension PlaceDetailsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlaceInfoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        return cell
    }
}
