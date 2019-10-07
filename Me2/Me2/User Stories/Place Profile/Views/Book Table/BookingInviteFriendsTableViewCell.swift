//
//  BookingInviteFriendsTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class BookingInviteFriendsTableViewCell: BookingTableViewCell {

    let picker = UIPickerView()
    let inviteFriendsView = UIView()
    let invitedFriendsView = UIView()
    
    var parentVC: BookTableViewController!
    
    func configure(with vc: BookTableViewController) {
        self.parentVC = vc
        
        titleLabel.text = BookingParameters.numberOfGuest.rawValue
        textField.rightViewImage = UIImage(named: "down_arrow")
        
        picker.dataSource = self
        picker.delegate = self
        textField.inputView = picker
        
        addInviteFriendsView()
        addInvitedFriendsView()
    }

    private func addInvitedFriendsView() {
        invitedFriendsView.isHidden = true
        
        self.contentView.addSubview(invitedFriendsView)
        constrain(invitedFriendsView, self.textField, self.contentView) { view, textField, contentView in
            view.left == contentView.left + 20
            view.right == contentView.right - 20
            view.top == textField.bottom + 10
            view.bottom == contentView.bottom
            view.height == 36
        }
    }
    
    private func addInviteFriendsView() {
        inviteFriendsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteFriends)))
        
        let icon = UIImageView(image: UIImage(named: "invite_friend"))
        inviteFriendsView.addSubview(icon)
        constrain(icon, inviteFriendsView) { icon, view in
            icon.height == 23
            icon.width == 25
            icon.centerY == view.centerY
            icon.left == view.left
        }
        
        let label = UILabel()
        label.textColor = Color.red
        label.font = UIFont(name: "Roboto-Medium", size: 15)
        label.text = "Пригласить друзей"
        inviteFriendsView.addSubview(label)
        constrain(label, icon) { label, icon in
            label.left == icon.right + 10
            label.centerY == icon.centerY
        }
        
        self.contentView.addSubview(inviteFriendsView)
        constrain(inviteFriendsView, self.textField, self.contentView) { view, textField, contentView in
            view.left == contentView.left + 20
            view.right == contentView.right - 20
            view.top == textField.bottom + 10
            view.bottom == contentView.bottom
            view.height == 36
        }
    }
    
    @objc private func inviteFriends() {
        let dest = Storyboard.addGuestsViewController() as! AddGuestsViewController
        dest.viewModel = AddGuestViewModel(onCompletion: { [weak self] (guestsList) in
            self?.showInvitedFriends(by: guestsList)
        })
        
        parentVC.present(dest, animated: true, completion: nil)
    }
    
    private func showInvitedFriends(by guestsList: [String]) {
        configureInvitedFriendsView(with: guestsList)
    
        if guestsList.count > 0 {
            inviteFriendsView.isHidden = true
            invitedFriendsView.isHidden = false
        } else {
            inviteFriendsView.isHidden = false
            invitedFriendsView.isHidden = true
        }
    }
    
    private func configureInvitedFriendsView(with guestsList: [String]) {
        invitedFriendsView.subviews.forEach({ $0.removeFromSuperview() })
        
        var x: CGFloat = 0
        let avatarSize: CGFloat = 36
        
        for guest in guestsList {
            let avatar = UIImageView(frame: CGRect(x: x, y: 0, width: avatarSize, height: avatarSize))
            avatar.image = UIImage(named: "sample_avatar")
            invitedFriendsView.addSubview(avatar)
            
            x += avatarSize - 10
        }
    }
}
