//
//  FollowButton.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class FollowButton: UIView {
    
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var checkmarkIcon: UIImageView!
    
    var isFollowed: Dynamic<Bool>?
    
    static func instanceFromNib() -> FollowButton {
        return UINib(nibName: "FollowButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FollowButton
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    private func configureViews() {
        checkmarkIcon.isHidden = true
    }
    
    func configure(with followed: Dynamic<Bool>) {
        self.isFollowed = followed
        
        self.isFollowed?.bind({ [weak self] (isFollowed) in
            switch isFollowed {
            case true:
                self?.checkmarkIcon.isHidden = false
                self?.addIcon.isHidden = true
                self?.followLabel.isHidden = true
            case false:
                self?.checkmarkIcon.isHidden = true
                self?.addIcon.isHidden = false
                self?.followLabel.isHidden = false
            }
        })
    }
}
