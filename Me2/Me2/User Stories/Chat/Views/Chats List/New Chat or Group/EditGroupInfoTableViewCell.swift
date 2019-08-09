//
//  EditGroupInfoTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/7/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EditGroupInfoTableViewCell: UITableViewCell {
    
    let avatarImageView = UIImageView()
    let titleTextField = UITextField()
    let imagePicker = UIImagePickerController()
    
    var controllerPresenter: ControllerPresenterDelegate!
    var actionSheetPresenter: ActionSheetPresenterDelegate!
    var titleChangeHandler: ((String)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure (controllerPresenter: ControllerPresenterDelegate, actionSheetPresenter: ActionSheetPresenterDelegate, titleChangeHandler: @escaping ((String) -> ())) {
        self.controllerPresenter = controllerPresenter
        self.actionSheetPresenter = actionSheetPresenter
        imagePicker.delegate = self
        self.titleChangeHandler = titleChangeHandler
    }
    
    private func setUpViews() {
        avatarImageView.image = UIImage(named: "add_photo")
        avatarImageView.layer.cornerRadius = 38
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tap)
        
        self.contentView.addSubview(avatarImageView)
        constrain(avatarImageView, self.contentView) { avatar, view in
            avatar.left == view.left + 10
            avatar.height == 76
            avatar.width == 76
            avatar.top == view.top + 20
            avatar.bottom == view.bottom - 20
        }
        
        titleTextField.borderStyle = .none
        titleTextField.font = UIFont(name: "Roboto-Regular", size: 17)
        titleTextField.placeholder = "Название группы"
        titleTextField.addTarget(self, action: #selector(textFielEdited), for: .editingChanged)
        self.contentView.addSubview(titleTextField)
        constrain(titleTextField, avatarImageView, self.contentView) { title, avatar, view in
            title.left == avatar.right + 17
            title.centerY == avatar.centerY
            title.right == view.right - 10
            title.height == 40
        }
        let frame = CGSize(width: UIScreen.main.bounds.width - 76 - 17 - 20, height: 40)
        titleTextField.addUnderline(with: .lightGray, and: frame)
    }
    
    @objc private func textFielEdited() {
        if let title = titleTextField.text {
            titleChangeHandler?(title)
        }
    }
    
    @objc private func chooseAvatar() {
        imagePicker.navigationBar.tintColor = .black
        imagePicker.allowsEditing = false
        
        let titles = ["Сделать снимок", "Выбрать фотографию"]
        let actions = [takePicture, chooseImageFromAlbum]
        actionSheetPresenter.present(with: titles, actions: actions, styles: [.default, .default])
    }
    
    func chooseImageFromAlbum() {
        imagePicker.sourceType = .photoLibrary
        controllerPresenter.present(controller: imagePicker)
    }
    
    func takePicture() {
        imagePicker.sourceType = .camera
        controllerPresenter.present(controller: imagePicker)
    }
}

extension EditGroupInfoTableViewCell : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarImageView.image = pickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

