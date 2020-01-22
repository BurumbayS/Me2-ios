//
//  GuestProfileHeaderTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import ImageSlideshow

class GuestProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageSlideShow: ImageSlideshow!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    
    var user: User!
    var viewModel: UserProfileViewModel!
    var parentVC: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    func configure(viewModel: UserProfileViewModel, viewController: UIViewController) {
        self.viewModel = viewModel
        self.user = viewModel.userInfo.value
        self.parentVC = viewController
        
        if let url = URL(string: user.avatar ?? "") {
            avatarImageSlideShow.setImageInputs([KingfisherSource(url: url, placeholder: UIImage(named: "placeholder_avatar"), options: [])])
        } else {
            avatarImageSlideShow.setImageInputs([ImageSource(image: UIImage(named: "placeholder_avatar")!)])
        }
        
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
        avatarImageSlideShow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showBigAvatar)))
        avatarImageSlideShow.contentScaleMode = .scaleAspectFill
    }
    
    @objc private func openInstagram() {
        if let url = URL(string: "https://www.instagram.com/\(user.instagram!)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func showBigAvatar() {
        avatarImageSlideShow.presentFullScreenController(from: parentVC)
    }
    
    @IBAction func wavePressed(_ sender: Any) {
        viewModel.getChatWithUser { [weak self] (status, message) in
            switch status {
            case .ok:
                
                if let room = self?.viewModel.chatRoom {
                    let vc = Storyboard.chatViewController() as! ChatViewController
                    vc.viewModel = ChatViewModel(room: room, shouldWave: true)
                    self?.parentVC.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .error,.fail:
                break
            }
        }
    }
    
    @IBAction func writePressed(_ sender: Any) {
        viewModel.getChatWithUser { [weak self] (status, message) in
            switch status {
            case .ok:
                
                if let room = self?.viewModel.chatRoom {
                    let vc = Storyboard.chatViewController() as! ChatViewController
                    vc.viewModel = ChatViewModel(room: room)
                    self?.parentVC.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .error,.fail:
                break
            }
        }
    }
}
