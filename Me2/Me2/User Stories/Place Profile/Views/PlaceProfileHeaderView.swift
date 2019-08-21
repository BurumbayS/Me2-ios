//
//  PlaceProfileHeaderView.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import Cosmos

class PlaceProfileHeaderView: UICollectionReusableView {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.backgroundColor = Color.blue
        
        let label = UILabel()
        label.textColor = Color.red
        label.text = "Hi there"
        label.font = UIFont(name: "Roboto-Regular", size: 23)
        
        self.addSubview(label)
        constrain(label, self) { label, view in
            label.left == view.left
            label.top == view.top
            label.right == view.right
            label.bottom == view.bottom
        }
    }
//    private func setUpViews() {
//        imageView.contentMode = .scaleAspectFill
//        imageView.image = UIImage(named: "sample_place_image")
//        self.addSubview(imageView)
//        constrain(imageView, self) { image, view in
//            image.left == view.left
//            image.top == view.top
//            image.right == view.right
//            image.bottom == view.bottom
//        }
//
//        let additionalView = UIView()
//        additionalView.layer.cornerRadius = 20.0
//        additionalView.backgroundColor = .white
//        self.addSubview(additionalView)
//        constrain(additionalView, self) { view, superView in
//            view.left == superView.left
//            view.height == 40
//            view.right == superView.right
//            view.bottom == superView.bottom + 20
//        }
//    }
}

class PlaceHeaderCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let ratingView = CosmosView()
    let ratingLabel = UILabel()
    let liveChatButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(title: String, rating: Double, category: String) {
        titleLabel.text = title
        ratingView.rating = rating
        categoryLabel.text = category
    }
    
    private func setUpViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "sample_place_image")
        self.addSubview(imageView)
        constrain(imageView, self) { image, view in
            image.left == view.left
            image.top == view.top
            image.right == view.right
//            image.bottom == view.bottom
        }
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 24)
        view.addSubview(titleLabel)
        constrain(titleLabel, view) { title, view in
            title.left == view.left + 27
            title.top == view.top + 28
        }
        
        categoryLabel.textColor = .darkGray
        categoryLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        view.addSubview(categoryLabel)
        constrain(categoryLabel, titleLabel) { category, title in
            category.leading == title.leading
            category.top == title.bottom + 7
        }
        
        ratingView.settings.starSize = 10
        ratingView.settings.starMargin = 3
        ratingView.settings.totalStars = 5
        ratingView.text = "3.2"
        view.addSubview(ratingView)
        constrain(ratingView, categoryLabel) { rating, category in
            rating.leading == category.leading
            rating.top == category.bottom + 7
            rating.height == 10
            rating.width == 65
        }
        
        liveChatButton.setTitleColor(Color.blue, for: .normal)
        liveChatButton.setTitle("Live Чат", for: .normal)
        liveChatButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 17)
        liveChatButton.layer.borderColor = Color.blue.cgColor
        liveChatButton.layer.borderWidth = 2.0
        liveChatButton.layer.cornerRadius = 5
        view.addSubview(liveChatButton)
        constrain(liveChatButton, titleLabel, view) { btn, title, view in
            btn.left == title.right + 10
            btn.right == view.right - 27
            btn.centerY == title.centerY
            btn.width == 82
            btn.height == 40
        }
        
        self.addSubview(view)
        constrain(view, imageView, self) { view, image, superview in
            view.top == image.bottom - 20
            view.left == superview.left
            view.right == superview.right
            view.bottom == superview.bottom
            view.height == 110
        }
    }
}
