//
//  PlaceProfileHeaderCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/21/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import Cosmos

class PlaceProfileHeaderCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let ratingView = CosmosView()
    let ratingLabel = UILabel()
    let liveChatButton = UIButton()
    let followButton = FollowButton.instanceFromNib()
    
    var followBtnSize = ConstraintGroup()
    var isFollowed: Dynamic<Bool> = Dynamic(false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        bindDynamics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(title: String, rating: Double, category: String) {
        titleLabel.text = title
        ratingView.rating = rating
        categoryLabel.text = category
    }
    
    private func bindDynamics() {
        isFollowed.bind { [weak self] (isFollowed) in
            switch isFollowed {
            case true:
                self?.updateFollowBtnSize(with: 38, and: 38)
            case false:
                self?.updateFollowBtnSize(with: 38, and: 142)
            }
        }
    }
    
    private func setUpViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "sample_place_image")
        self.addSubview(imageView)
        constrain(imageView, self) { image, view in
            image.left == view.left
            image.top == view.top
            image.right == view.right
        }
        
        setUpTopBar()
        setUpPlaceHeader()
    }
    
    private func setUpTopBar() {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "custom_back_button"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.addSubview(backButton)
        constrain(backButton, self) { btn, view in
            btn.left == view.left + 11
            btn.top == view.top + 50
            btn.width == 38
            btn.height == 38
        }
        
        //Share button
        let shareView = UIView()
        shareView.layer.cornerRadius = 19
        shareView.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 0.9)
        
        let shareButton = UIButton()
        shareButton.setImage(UIImage(named: "share_icon"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareWithPlace), for: .touchUpInside)
        shareView.addSubview(shareButton)
        constrain(shareButton, shareView) { btn, view in
            btn.centerX == view.centerX
            btn.centerY == view.centerY
            btn.width == 16
            btn.height == 22
        }
        
        self.addSubview(shareView)
        constrain(shareView, self) { share, view in
            share.right == view.right - 17
            share.top == view.top + 50
            share.height == 38
            share.width == 38
        }
        
        //Follow button
        followButton.configure(with: self.isFollowed)
        followButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followPlace)))
        self.addSubview(followButton)
        constrain(followButton, shareView, self) { btn, share, view in
            btn.right == share.left - 16
            btn.top == view.top + 50
        }
        constrain(followButton, replace: followBtnSize) { btn in
            btn.height == 38
            btn.width == 142
        }
    }
    
    private func setUpPlaceHeader() {
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
    
    @objc private func goBack() {
        
    }
    
    @objc private func shareWithPlace() {
        
    }
    
    @objc private func followPlace() {
        isFollowed.value = !isFollowed.value
    }
    
    private func updateFollowBtnSize(with height: CGFloat, and width: CGFloat) {
        constrain(followButton, replace: followBtnSize) { btn in
            btn.height == height
            btn.width == width
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
