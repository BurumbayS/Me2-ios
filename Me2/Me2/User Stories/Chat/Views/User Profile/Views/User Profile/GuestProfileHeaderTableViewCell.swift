//
//  GuestProfileHeaderTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class GuestProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    
    var user: User!
    
    func configure(user: User) {
        self.user = user
        
        avatarImageView.kf.setImage(with: URL(string: user.avatar ?? ""), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        usernameLabel.text = user.username
        fullNameLabel.text = user.fullName ?? ""
        bioLabel.text = user.bio ?? ""
        if let instagram = user.instagram, instagram != "" {
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
    }
    
    @objc private func openInstagram() {
        if let url = URL(string: "https://www.instagram.com/\(user.instagram!)") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func wavePressed(_ sender: Any) {
    }
    
    @IBAction func writePressed(_ sender: Any) {
    }
}
