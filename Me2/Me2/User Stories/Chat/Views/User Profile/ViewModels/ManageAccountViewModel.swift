//
//  ManageAccountViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum VisibilityParameter {
    case avatar
    case name
    case age
    
    var title: String {
        switch self {
        case .avatar:
            return "Видимость аватара"
        case .name:
            return "Видимость имени и фамилии"
        case .age:
            return "Видимость возраста"
        }
    }
}

enum NotificationsParameter {
    case directMessages
    case liveChat
    case tableBookingStatus
    case newEvents
    
    var title: String {
        switch self {
        case .directMessages:
            return "Личные сообщения"
        case .liveChat:
            return "LIVE-чаты"
        case .tableBookingStatus:
            return "Статус брони столика"
        case .newEvents:
            return "Новые события и акции"
        }
    }
}

enum SecurityParameter {
    case changePassword
    case changePhoneNumber
    case accessCode
    
    var title: String {
        switch self {
        case .changePassword:
            return "Изменить пароль"
        case .changePhoneNumber:
            return "Изменить номер телефона"
        case .accessCode:
            return "Код быстрого доступа"
        }
    }
}

class ManageAccountViewModel {
    let sections = [ManageAccountSectionType.privacy, .notification, .security, .delete]
    let visibilityParameters = [VisibilityParameter.avatar, .name, .age]
    let notificationsParameters = [NotificationsParameter.directMessages, .liveChat, .tableBookingStatus, .newEvents]
    let securityParameters = [SecurityParameter.changePassword, .changePhoneNumber, .accessCode]
    
    func cellsCount(for section: Int) -> Int {
        let type = sections[section]
        
        switch type {
        case .privacy:
            return visibilityParameters.count
        case .notification:
            return notificationsParameters.count
        case .security:
            return securityParameters.count
        case .delete:
            return 1
        }
    }
    
    func modelForCell(at indexPath: IndexPath) -> ManageAccountParameterModel {
        switch sections[indexPath.section] {
        case .privacy:
            return ManageAccountParameterModel(title: visibilityParameters[indexPath.row].title, type: .privacy)
        case .notification:
            return ManageAccountParameterModel(title: notificationsParameters[indexPath.row].title, type: .notification)
        case .security:
            return ManageAccountParameterModel(title: securityParameters[indexPath.row].title, type: .security)
        case .delete:
            return ManageAccountParameterModel(title: "Удалить аккаунт", type: .delete)
        }
    }
}
