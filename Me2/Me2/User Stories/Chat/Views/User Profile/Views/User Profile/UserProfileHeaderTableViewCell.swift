//
//  UserProfileHeaderTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class UserProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameAndAgeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    
    var parentVC: UIViewController!
    var user: Dynamic<User>!
    
    func configure(user: Dynamic<User>, viewController: UIViewController) {
        self.user = user
        
        avatarImageView.kf.setImage(with: URL(string: user.value.avatar ?? ""), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        usernameLabel.text = user.value.username
        nameAndAgeLabel.text = user.value.fullName ?? ""
        bioLabel.text = user.value.bio ?? ""
    }
    
    @IBAction func editPressed(_ sender: Any) {
        let vc = Storyboard.editProfileViewController() as! EditProfileViewController
        vc.viewModel = EditProfileViewModel(userInfo: user)
        parentVC.present(vc, animated: true, completion: nil)
    }
}
