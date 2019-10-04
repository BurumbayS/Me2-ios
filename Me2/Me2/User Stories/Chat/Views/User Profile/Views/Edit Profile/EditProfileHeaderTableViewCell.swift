//
//  EditProfileHeaderTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Kingfisher

class EditProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    }
    
    func configure(with data: [String: String]) {
        avatarImageView.kf.setImage(with: URL(string: data["avatar"] ?? ""), placeholder: UIImage(named: "placeholder_image"), options: [])
        usernameTextField.placeholder = data["username"]
    }
    
    @IBAction func changeAvatarPressed(_ sender: Any) {
    }
}
