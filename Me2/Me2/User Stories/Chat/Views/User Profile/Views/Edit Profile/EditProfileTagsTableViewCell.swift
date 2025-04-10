//
//  EditProfileTagsTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EditProfileTagsTableViewCell: UITableViewCell {

    var tagViews = [RemovableTag]()
    var didLayoutSubviews = false
    
    let titleLabel = UILabel()
    let tagsView = UIView()
    var addTagButton = UIButton()
    var textField = UITextField()
    
    var tagsViewHeightConstraint = ConstraintGroup()
    var tagsViewHeight: CGFloat = 0
    let itemPadding: CGFloat = 10
    let itemHeight: CGFloat = 30
    let sidesPadding: CGFloat = 20
    let addTagButtonHeight: CGFloat = 30
    let addTagButtonWidth: CGFloat = 145
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    var updateHandler: VoidBlock?
    
    var tags = [String]()
    var dataToSave: UserDataToSave!
    
    var tagsEditing = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(tags: [String], userDataToSave: UserDataToSave, activateTagAddition: Bool, onUpdate: VoidBlock?) {
        self.updateHandler = onUpdate
        self.tags = tags
        self.dataToSave = userDataToSave
        
        if !self.didLayoutSubviews {
            setUpViews()
        }
        
        if activateTagAddition {
            textField.becomeFirstResponder()
        }
    }
    
    private func setUpViews() {
        setUpTitle()
        setUpTags()
        setUpTagsView()
        
        didLayoutSubviews = true
    }
    
    private func setUpTitle() {
        titleLabel.textColor = .darkGray
        titleLabel.text = "Интересы"
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { title, view in
            title.top == view.top + 20
            title.left == view.left + 20
            title.height == 15
        }
    }
    
    private func setUpTagsView() {
        self.contentView.addSubview(tagsView)
        constrain(tagsView, titleLabel, self.contentView) { view, title, superView in
            view.left == superView.left + sidesPadding
            view.right == superView.right - sidesPadding
            view.top == title.bottom + 10
            view.bottom == superView.bottom
        }
    }
    
    private func setUpTags() {
        tagViews.forEach { $0.removeFromSuperview() }
        addTagButton.removeFromSuperview()
        tagViews = []
        
        addTags()
        
        setUpAddTagButton()
        setUpTextField()
        
        tagsViewHeight = y + itemHeight
        updateHeight()
    }
    
    private func addTags() {
        x = 0
        y = 0
        
        for (i, tag) in tags.enumerated() {
            // calculate tag width by label width + sides padding and button size
            let width = tag.getWidth(with: UIFont(name: "Roboto-Regular", size: 15)!) + 50
            
            if x + width + sidesPadding > UIScreen.main.bounds.width - sidesPadding {
                x = 0
                y += itemHeight + itemPadding
            }
            
            let tagView = RemovableTag(frame: CGRect(x: x, y: y, width: width, height: itemHeight))
            tagView.configure(with: tag) { [weak self] in
                self?.removeTag(at: i)
            }
            tagViews.append(tagView)
            
            tagsView.addSubview(tagView)
            
            x += width + itemPadding
        }
    }
    
    private func setUpAddTagButton() {
        if x + addTagButtonWidth > UIScreen.main.bounds.width - sidesPadding {
            x = 0
            y += itemHeight + itemPadding
        }
        
        addTagButton = UIButton(frame: CGRect(x: x, y: y, width: addTagButtonWidth, height: addTagButtonHeight))
        addTagButton.setTitle("+ Добавить интерес", for: .normal)
        addTagButton.setTitleColor(Color.red, for: .normal)
        addTagButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        addTagButton.addTarget(self, action: #selector(addNewTagPressed), for: .touchUpInside)
        addTagButton.isHidden = tagsEditing
        
        tagsView.addSubview(addTagButton)
    }
    
    private func setUpTextField() {
        textField = UITextField(frame: CGRect(x: x, y: y, width: addTagButtonWidth, height: addTagButtonHeight))
        textField.font = UIFont(name: "Roboto-Regular", size: 15)
        textField.textColor = .black
        textField.delegate = self
        textField.returnKeyType = .next
        textField.isHidden = !tagsEditing
        if tagsEditing { textField.becomeFirstResponder() }
        
        tagsView.addSubview(textField)
    }
    
    @objc private func addNewTagPressed() {
        textField.becomeFirstResponder()
    }
    
    private func removeTag(at index: Int) {
        tags.remove(at: index)
        dataToSave.data = tags
        
        setUpTags()
        updateHandler?()
    }
    
    private func addTag(with title: String) {
        tags.append(title)
        dataToSave.data = tags
        
        setUpTags()
        updateHandler?()
    }

    func updateHeight() {
        constrain(tagsView, replace: tagsViewHeightConstraint) { view in
            view.height == tagsViewHeight
        }
        
        layoutIfNeeded()
    }
}

extension EditProfileTagsTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tagsEditing = true
        
        textField.isHidden = false
        addTagButton.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tagsEditing = false
        
        if let title = textField.text, title != "" {
            addTag(with: title)
        } else {
            textField.isHidden = true
            addTagButton.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let title = textField.text, title != "" {
            textField.text = ""
            addTag(with: title)
        }
        
        return true
    }
}
