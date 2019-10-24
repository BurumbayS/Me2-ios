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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    }
    
    func configure(with data: [String: String], controllerPresenter: ControllerPresenterDelegate, actionSheetPresenter: ActionSheetPresenterDelegate) {
        self.controllerPresenter = controllerPresenter
        self.actionSheetPresenter = actionSheetPresenter
        self.imagePicker.delegate = self
        
        avatarImageView.kf.setImage(with: URL(string: data["avatar"] ?? ""), placeholder: UIImage(named: "placeholder_image"), options: [])
        usernameTextField.placeholder = data["username"]
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
        controllerPresenter.present(controller: imagePicker, presntationType: .present)
    }
    
    func takePicture() {
        imagePicker.sourceType = .camera
        controllerPresenter.present(controller: imagePicker, presntationType: .present)
    }
}

extension EditProfileHeaderTableViewCell : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarImageView.image = pickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
