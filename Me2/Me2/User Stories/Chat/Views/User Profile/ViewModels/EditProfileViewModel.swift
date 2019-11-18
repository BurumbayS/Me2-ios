//
//  EditProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum EditProfileCell: String {
    case mainInfo
    case firstname
    case lastname
    case dateOfBirth
    case bio
    case instagram
    case interests
    
    var title: String {
        switch self {
        case .firstname:
            return "Имя"
        case .lastname:
            return "Фамилия"
        case .dateOfBirth:
            return "Дата рождения"
        case .bio:
            return "Био"
        case .instagram:
            return "Instagram логин"
        case .interests:
            return "Интересы"
        default:
            return ""
        }
    }
    
    var key: String {
        switch self {
        case .firstname:
            return "first_name"
        case .lastname:
            return "last_name"
        case .dateOfBirth:
            return "birth_date"
        case .bio:
            return "bio"
        case .instagram:
            return "instagram"
        case .interests:
            return "interests"
        default:
            return "main_info"
        }
    }
}

class EditProfileViewModel {
    let cells = [EditProfileCell.mainInfo, .firstname, .lastname, .dateOfBirth, .bio, .instagram, .interests]
    var dataToSave = [UserDataToSave]()
    
    var userInfo: Dynamic<User>!
    
    let activateAddTagTextField: Bool
    
    init(userInfo: Dynamic<User>, activateAddTag: Bool = false) {
        self.userInfo = userInfo
        self.activateAddTagTextField = activateAddTag
        
        for cell in cells {
            dataToSave.append(UserDataToSave(key: cell.key))
        }
    }
    
    func dataFor(cellType: EditProfileCell) -> [String: String?] {
        switch cellType {
        case .mainInfo:
            return ["avatar" : userInfo.value.avatar,
                    "username" : userInfo.value.username]
        case .firstname:
            return ["firstname" : userInfo.value.firstName]
        case .lastname:
            return ["lastname" : userInfo.value.lastName]
        case .dateOfBirth:
            return ["dateOfBirth" : userInfo.value.birthDate]
        case .bio:
            return ["bio" : userInfo.value.bio]
        case .instagram:
            return ["instagram": userInfo.value.instagram]
        case .interests:
            return ["" : ""]
        }
    }
    
    func updateProfile(completion: ResponseBlock?) {
        var params = [String: Any]()
        dataToSave.forEach{ params[$0.key] = $0.data}
        params[EditProfileCell.mainInfo.key] = nil
        
        var thereIsAvatarToUpdate = false
        
        if let mainInfo = dataToSave.first(where: { $0.key == EditProfileCell.mainInfo.key })?.data as? [String: Any] {
            if let username = mainInfo["username"] as? String {
                params["username"] = username
            }
            
            if let imageData = mainInfo["avatar"] as? Data {
                thereIsAvatarToUpdate = true
                
                uploadAvatar(imageData: imageData) { [weak self] (id) in
                    params["avatar_id"] = id
                    
                    self?.updateData(with: params, completion: completion)
                }
            }
        }
        
        if !thereIsAvatarToUpdate {
            updateData(with: params, completion: completion)
        }
    }
    
    private func updateData(with params: [String: Any], completion: ResponseBlock?) {
        Alamofire.request(updateUserProfileURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self.userInfo.value = User(json: json["data"]["user"])
                    
                    completion?(.ok, "")
                    
                case .failure( _):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    private func uploadAvatar(imageData: Data, completion: ((Int) -> ())?) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
            
        }, usingThreshold: UInt64.init(), to: uploadImageURL, method: .post, headers: Network.getAuthorizedHeaders()) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(response.data as Any)
                    completion?(json["data"]["id"].intValue)
                    
                }
                
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion?(0)
            }
        }
    }
    
    let updateUserProfileURL = Network.user + "/update_profile/"
    let uploadImageURL = Network.host + "/image/"
}
