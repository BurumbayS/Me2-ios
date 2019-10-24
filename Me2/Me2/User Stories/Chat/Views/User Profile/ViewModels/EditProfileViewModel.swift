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
        case .interests:
            return "interests"
        default:
            return "main_info"
        }
    }
}

class EditProfileViewModel {
    let cells = [EditProfileCell.mainInfo, .firstname, .lastname, .dateOfBirth, .bio, .interests]
    var dataToSave = [UserDataToSave]()
    
    let activateAddTagTextField: Bool
    
    init(activateAddTag: Bool = false) {
        self.activateAddTagTextField = activateAddTag
        
        for cell in cells {
            dataToSave.append(UserDataToSave(key: cell.key))
        }
    }
    
    func dataFor(cellType: EditProfileCell) -> [String: String] {
        switch cellType {
        case .mainInfo:
            return ["avatar" : "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg",
                    "username" : "Einstein_emc"]
        case .firstname:
            return ["firstname" : "Альберт"]
        case .lastname:
            return ["lastname" : "Эйнштейн"]
        case .dateOfBirth:
            return ["dateOfBirth" : "14 марта 1879"]
        case .bio:
            return ["bio" : "Интересуюсь физикой и другими науками. В свободное время выращиваю розы и играю на скрипке. Подписывайтесь на мою страницу в инстаграме @einstein_emc"]
        case .interests:
            return ["" : ""]
        }
    }
    
    func updateProfile() {
        var params = [String: Any]()
        dataToSave.forEach{ params[$0.key] = $0.data}
        
        if let mainInfo = dataToSave.first(where: { $0.key == EditProfileCell.mainInfo.key })?.data as? [String: Any] {
            if let username = mainInfo["username"] as? String {
                params["username"] = username
            }
        }
        
        Alamofire.request(updateUserProfileURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    let updateUserProfileURL = Network.user + "/update_profile/"
}
