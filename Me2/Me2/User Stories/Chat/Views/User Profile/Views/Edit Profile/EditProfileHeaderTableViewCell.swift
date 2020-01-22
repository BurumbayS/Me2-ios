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
    
    let imagePicker = UIImagePickerController()
    
    var controllerPresenter: ControllerPresenterDelegate!
    var actionSheetPresenter: ActionSheetPresenterDelegate!
    
    var dataToSave: UserDataToSave!
    var data = [String: Any]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        usernameTextField.delegate = self
        usernameTextField.placeholder = "Einstein_emc"
    }
    
    func configure(with data: [String: String?], userDataToSave: UserDataToSave, controllerPresenter: ControllerPresenterDelegate, actionSheetPresenter: ActionSheetPresenterDelegate) {
        self.dataToSave = userDataToSave
        self.controllerPresenter = controllerPresenter
        self.actionSheetPresenter = actionSheetPresenter
        self.imagePicker.delegate = self
        
        avatarImageView.kf.setImage(with: URL(string: (data["avatar"] as? String) ?? ""), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        if let username = data["username"] as? String {
            usernameTextField.text = username
        }
    }
    
    @IBAction func changeAvatarPressed(_ sender: Any) {
        imagePicker.navigationBar.tintColor = .black
        imagePicker.allowsEditing = false
        
        let titles = ["Сделать снимок", "Выбрать фотографию"]
        let actions = [takePicture, chooseImageFromAlbum]
        actionSheetPresenter.present(with: titles, actions: actions, styles: [.default, .default])
    }
    
    func chooseImageFromAlbum() {
        imagePicker.sourceType = .photoLibrary
        controllerPresenter.present(controller: imagePicker, presntationType: .present, completion: nil)
    }
    
    func takePicture() {
        imagePicker.sourceType = .camera
        controllerPresenter.present(controller: imagePicker, presntationType: .present, completion: nil)
    }
}

extension EditProfileHeaderTableViewCell : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarImageView.image = pickedImage
            
            if let imageData = pickedImage.jpegData(compressionQuality: 0.1) {
                data["avatar"] = imageData
                dataToSave.data = data
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        data["username"] = textField.text
        dataToSave.data = data
    }
}
