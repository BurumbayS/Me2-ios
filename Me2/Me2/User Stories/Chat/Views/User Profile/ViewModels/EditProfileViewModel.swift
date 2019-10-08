//
//  EditProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum EditProfileCell: String {
    case mainInfo = ""
    case firstname = "Имя"
    case lastname = "Фамилия"
    case dateOfBirth = "Дата рождения"
    case bio = "Био"
    case interests = "Интересы"
    case phoneNumber = "Номер телефона"
}

class EditProfileViewModel {
    let cells = [EditProfileCell.mainInfo, .firstname, .lastname, .dateOfBirth, .bio, .interests, .phoneNumber]
    
    let activateAddTagTextField: Bool
    
    init(activateAddTag: Bool = false) {
        self.activateAddTagTextField = activateAddTag
    }
    
    func dataFor(cellType: EditProfileCell) -> [String: String] {
        switch cellType {
        case .mainInfo:
            return ["avatar" : "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg",
                    "username" : "KennyS"]
        case .firstname:
            return ["firstname" : "Hello"]
        case .lastname:
            return ["lastname" : "World"]
        case .dateOfBirth:
            return ["dateOfBirth" : "14 марта 1996"]
        case .bio:
            return ["bio" : "Интересуюсь физикой и другими науками. В свободное время выращиваю розы и играю на скрипке. Подписывайтесь на мою страницу в инстаграме @einstein_emc"]
        case .phoneNumber:
            return ["phoneNumber" : "+7 (777) *** **77"]
        case .interests:
            return ["" : ""]
        }
    }
}
