//
//  ParticipantCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ParticipantCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with user: ChatParticipant) {
        logoImageView.kf.setImage(with: URL(string: user.avatar), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        titleLabel.text = user.username
    }
}
