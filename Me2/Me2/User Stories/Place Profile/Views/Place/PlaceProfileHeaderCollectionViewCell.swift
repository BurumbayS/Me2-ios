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
import ImageSlideshow
import Kingfisher

class PlaceProfileHeaderCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let wallpaperView = UIView()
    let imageCarousel = ImageSlideshow()
    
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let ratingView = CosmosView()
    let ratingLabel = UILabel()
    let liveChatButton = UIButton()
    let followButton = FollowButton.instanceFromNib()
    
    var followBtnSize = ConstraintGroup()
    var isFollowed: Dynamic<Bool> = Dynamic(false)
    var parentVC: UIViewController!
    var placeStatus: PlaceStatus!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        bindDynamics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(place: Place, viewController: UIViewController) {
        self.placeStatus = place.regStatus
        titleLabel.text = place.name
        categoryLabel.text = place.category ?? ""
        logoImageView.kf.setImage(with: URL(string: place.logo ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        
        if let rating = place.rating {
            let roundedRating = Double(round(rating * 10) / 10)
            ratingView.rating = roundedRating
            ratingView.text = "\(roundedRating)"
        } else {
            ratingView.isHidden = true
        }
        
        var imageInputs = [InputSource]()
        for imageURL in place.images {
            let source = KingfisherSource(url: URL(string: imageURL)!, placeholder: UIImage(named: "default_place_wallpaper"), options: [])
            imageInputs.append(source)
        }
        imageCarousel.setImageInputs(imageInputs)
        
        parentVC = viewController
        
        configureViews()
    }
    
    private func configureViews() {
        switch placeStatus {
        case .registered?:
            imageView.isHidden = true
            imageCarousel.isHidden = false
            followButton.isHidden = false
        case .not_registered?:
            imageView.isHidden = false
            imageCarousel.isHidden = true
            followButton.isHidden = true
        default:
            break
        }
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
        setUpWallpaperView()
        setUpTopBar()
        setUpPlaceHeader()
    }
    
    private func setUpWallpaperView() {
        setUpDefaultWalppaper()
        setupImageCarousel()
        
        self.contentView.addSubview(wallpaperView)
        constrain(self.wallpaperView, self.contentView) { wallpaper, view in
            wallpaper.left == view.left
            wallpaper.top == view.top
            wallpaper.right == view.right
        }
    }
    
    private func setUpDefaultWalppaper() {
        imageView.image = UIImage(named: "default_place_wallpaper")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.wallpaperView.addSubview(imageView)
        constrain(imageView, self.wallpaperView) { image, view in
            image.left == view.left
            image.top == view.top
            image.right == view.right
            image.bottom == view.bottom
        }
    }
    
    private func setupImageCarousel() {
        imageCarousel.contentScaleMode = .scaleAspectFill
        imageCarousel.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customBottom(padding: 30))
        imageCarousel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImages)))
        self.wallpaperView.addSubview(imageCarousel)
        constrain(imageCarousel, self.wallpaperView) { image, view in
            image.left == view.left
            image.top == view.top
            image.right == view.right
            image.bottom == view.bottom
        }
    }
    
    private func setUpTopBar() {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "custom_back_button"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.contentView.addSubview(backButton)
        constrain(backButton, self.contentView) { btn, view in
            btn.left == view.left + 17
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
        
        self.contentView.addSubview(shareView)
        constrain(shareView, self.contentView) { share, view in
            share.right == view.right - 17
            share.top == view.top + 50
            share.height == 38
            share.width == 38
        }
        
        //Follow button
        followButton.configure(with: self.isFollowed)
        followButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followPlace)))
        self.contentView.addSubview(followButton)
        constrain(followButton, shareView, self.contentView) { btn, share, view in
            btn.right == share.left - 16
            btn.top == view.safeAreaLayoutGuide.top + 50
        }
        constrain(followButton, replace: followBtnSize) { btn in
            btn.height == 38
            btn.width == 142
        }
    }
    
    private func setUpPlaceHeader() {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        
        logoImageView.layer.cornerRadius = 20
        logoImageView.clipsToBounds = true
        view.addSubview(logoImageView)
        constrain(logoImageView, view) { logo, view in
            logo.left == view.left + 20
            logo.top == view.top + 20
            logo.height == 40
            logo.width == 40
        }
        
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 17)
        view.addSubview(titleLabel)
        constrain(titleLabel, logoImageView) { title, logo in
            title.left == logo.right + 10
            title.centerY == logo.centerY
            title.top == logo.top
            title.bottom == logo.bottom
        }
        
        ratingView.settings.starSize = 10
        ratingView.settings.starMargin = 3
        ratingView.settings.totalStars = 5
        view.addSubview(ratingView)
        constrain(ratingView, logoImageView) { rating, logo in
            rating.leading == logo.leading
            rating.top == logo.bottom + 10
            rating.height == 15
            rating.width == 90
        }
        
        categoryLabel.textColor = .darkGray
        categoryLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        view.addSubview(categoryLabel)
        constrain(categoryLabel, ratingView) { category, rating in
            category.leading == rating.leading
            category.top == rating.bottom + 5
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
        
        self.contentView.addSubview(view)
        constrain(view, wallpaperView, self.contentView) { view, image, superview in
            view.top == image.bottom - 20
            view.left == superview.left
            view.right == superview.right
            view.bottom == superview.bottom
            view.height == 110
        }
    }
    
    @objc private func goBack() {
        parentVC.navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareWithPlace() {
        
    }
    
    @objc private func showImages() {
        imageCarousel.presentFullScreenController(from: parentVC)
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
