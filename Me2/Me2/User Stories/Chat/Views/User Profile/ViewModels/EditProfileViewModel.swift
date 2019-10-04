//
//  EditProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum EditProfileCells: String {
    case mainInfo = ""
    case firstname = "Имя"
    case lastname = "Фамилия"
    case dateOfBirth = "Дата рождения"
    case bio = "Био"
    case interests = "Интересы"
    case phoneNumber = "Номер телефона"
}

class EditProfileViewModel {
    let cells = [EditProfileCells.mainInfo, .firstname, .lastname, .dateOfBirth]
}
