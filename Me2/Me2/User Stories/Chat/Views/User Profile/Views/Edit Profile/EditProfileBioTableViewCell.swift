//
//  EditProfileBioTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EditProfileBioTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let textView = UITextView()
    
    var dataToSave: UserDataToSave!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: [String : String], userDataToSave: UserDataToSave, cellType: EditProfileCell) {
        self.dataToSave = userDataToSave
        
        titleLabel.text = cellType.rawValue
        textView.text = data["bio"]
    }
    
    private func setUpViews() {
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { label, view in
            label.top == view.top + 20
            label.left == view.left + 20
        }
        
        textView.delegate = self
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        textView.layer.cornerRadius = 5
        textView.backgroundColor = .white
        textView.textColor = Color.gray
        textView.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(textView)
        constrain(textView, titleLabel, self.contentView) { textView, label, view in
            textView.left == view.left + 20
            textView.top == label.bottom + 5
            textView.right == view.right - 20
            textView.bottom == view.bottom
            textView.height == 100
        }
    }
}

extension EditProfileBioTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        dataToSave.data = textView.text
    }
}
