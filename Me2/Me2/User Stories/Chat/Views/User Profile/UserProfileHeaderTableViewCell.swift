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
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var likedImageView: UIImageView!
    @IBOutlet weak var likedImageHeight: NSLayoutConstraint!
    @IBOutlet weak var likedImageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    private func configureViews() {
        likedImageHeight.constant = 0
        likedImageWidth.constant = 0
    }
    
    @IBAction func likedButtonPressed(_ sender: Any) {
        likedImageView.isHidden = false
        
        likedImageHeight.constant = 33
        likedImageWidth.constant = 41
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    @IBAction func writeButtonPressed(_ sender: Any) {
    }
}
