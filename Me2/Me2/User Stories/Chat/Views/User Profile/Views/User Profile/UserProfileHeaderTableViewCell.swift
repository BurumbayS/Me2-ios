//
//  UserProfileHeaderTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import ImageSlideshow

class UserProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameAndAgeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var avatarImageSlideShow: ImageSlideshow!
    
    var parentVC: UIViewController!
    var user: Dynamic<User>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    func configure(user: Dynamic<User>, viewController: UIViewController) {
        self.user = user
        self.parentVC = viewController
        
        if let url = URL(string: user.value.avatar ?? "") {
            avatarImageSlideShow.setImageInputs([KingfisherSource(url: url, placeholder: UIImage(named: "placeholder_avatar"), options: [])])
        } else {
            avatarImageSlideShow.setImageInputs([ImageSource(image: UIImage(named: "placeholder_avatar")!)])
        }
        
        usernameLabel.text = user.value.username
        nameAndAgeLabel.text = user.value.fullName ?? ""
        bioLabel.text = user.value.bio ?? ""
        
        if let instagram = user.value.instagram, instagram != "" {
            instagramLabel.textColor = Color.blue
            instagramLabel.isUserInteractionEnabled = true
            instagramLabel.text = instagram
        } else {
            instagramLabel.textColor = .lightGray
            instagramLabel.isUserInteractionEnabled = false
            instagramLabel.text = "не указан"
        }
    }
    
    private func configureViews() {
        instagramLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInstagram)))
        avatarImageSlideShow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showBigAvatar)))
        avatarImageSlideShow.contentScaleMode = .scaleAspectFill
    }
    
    @objc private func openInstagram() {
        if let url = URL(string: "https://www.instagram.com/\(user.value.instagram!)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func showBigAvatar() {
        avatarImageSlideShow.presentFullScreenController(from: parentVC)
    }
    
    @IBAction func editPressed(_ sender: Any) {
        let vc = Storyboard.editProfileViewController() as! EditProfileViewController
        vc.viewModel = EditProfileViewModel(userInfo: user)
        parentVC.present(vc, animated: true, completion: nil)
    }
}
