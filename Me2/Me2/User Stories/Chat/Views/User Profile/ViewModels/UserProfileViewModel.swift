//
//  UserProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

enum MyProfileAdditionalBlockCell: String {
    case contacts = "Мои контакты"
    case notifications = "Уведомления"
    case settings = "Управление аккаунтом"
    case feedback = "Обратная связь"
    case aboutApp = "О приложении"
    case logout = "Выйти"
    
    var icon: UIImage {
        switch self {
        case .contacts:
            return UIImage(named: "contacts_icon")!
        case .notifications:
            return UIImage(named: "notifications_icon")!
        case .settings:
            return UIImage(named: "settings_icon")!
        case .feedback:
            return UIImage(named: "feedback_icon")!
        case .aboutApp:
            return UIImage(named: "about_app_icon")!
        case .logout:
            return UIImage(named: "logout_icon")!
        }
    }
}

enum GuestProfileAdditionalBlockCell: String {
    case addContact = "Добавить в контакты"
    case removeContact = "Удалить из контактов"
    case block = "Заблокировать"
    case compplain = "Пожаловаться на пользователя"
}

enum ProfileType {
    case myProfile
    case guestProfile
}

enum UserProfileSection: String {
    case bio = "Био"
    case interests = "Интересы"
    case favourite_places = "Любимые места"
    case additional_block = ""
}

class UserProfileViewModel {
    var profileType = ProfileType.guestProfile
    let sections = [UserProfileSection.bio, .interests, .favourite_places, .additional_block]
    let myProfileCells = [MyProfileAdditionalBlockCell.contacts, .notifications, .settings, .feedback, .aboutApp, .logout]
    let guestProfileCells = [GuestProfileAdditionalBlockCell.addContact, .block, .compplain]
    
    func getNumberOfCellsForAdditionalBlock() -> Int{
        switch profileType {
        case .myProfile:
            return myProfileCells.count
        default:
            return guestProfileCells.count
        }
    }
}
