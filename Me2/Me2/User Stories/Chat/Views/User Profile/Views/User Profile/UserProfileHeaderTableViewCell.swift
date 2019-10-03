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
    @IBOutlet weak var actionToProfileView: UIView!
    @IBOutlet weak var actionToProfileViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bioLabel: UILabel!
    
    var presenterDelegate: ControllerPresenterDelegate!
    
    func configure(with profileType: ProfileType, and delegate: ControllerPresenterDelegate) {
        self.presenterDelegate = delegate
        
        if profileType == .myProfile {
            actionToProfileView.isHidden = true
            actionToProfileViewHeight.constant = 0
            editButton.isHidden = false
        } else {
            actionToProfileView.isHidden = false
            actionToProfileViewHeight.constant = 60
            editButton.isHidden = true
        }
    }
    
    @IBAction func editPressed(_ sender: Any) {
        let vc = Storyboard.editProfileViewController()
        presenterDelegate.present(controller: vc)
    }
    
    @IBAction func wavePressed(_ sender: Any) {
    }
    
    @IBAction func writePressed(_ sender: Any) {
    }
}
