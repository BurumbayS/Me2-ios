//
//  ContactTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/6/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

enum CheckStatus: String {
    case checked = "checked"
    case unchecked = "unchecked"
    
    func image() -> UIImage {
        return UIImage(named: self.rawValue) ?? UIImage()
    }
}

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var checkStatusImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addedLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var checked = CheckStatus.unchecked
    var addPressHandler: VoidBlock?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addUnderline(with: Color.gray, and: self.contentView.frame.size)
    }
    
    func configure(contact: ContactUser, selectable: Bool = false, addable: Bool = false, added: Bool = false, onAdd: VoidBlock? = nil) {
        self.addPressHandler = onAdd
        
        switch selectable {
        case true:
            checkStatusImageView.isHidden = false
            checkStatusImageView.image = checked.image()
        default:
            checkStatusImageView.isHidden = true
        }
        
        switch addable {
        case true:
            addButton.isHidden = added
            addedLabel.isHidden = !added
        default:
            addButton.isHidden = true
            addedLabel.isHidden = true
        }
        
        configureViews(for: contact)
    }
    
    private func configureViews(for contact: ContactUser) {
        avatarImageView.kf.setImage(with: URL(string: contact.avatar ?? ""), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        nameLabel.text = contact.fullName
        usernameLabel.text = contact.username
    }
    
    func select() {
        switch checked {
        case .checked:
            checked = .unchecked
        default:
            checked = .checked
        }
        
        checkStatusImageView.image = checked.image()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addPressHandler?()
    }
    
}
