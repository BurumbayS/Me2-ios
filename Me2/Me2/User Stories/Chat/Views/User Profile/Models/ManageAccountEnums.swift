//
//  Enums.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/15/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum VisibilityStatus: String {
    case INSIDE
    case ALWAYS
    case NEVER
    
    var title: String {
        switch self {
        case .INSIDE:
            return "Только в заведениях"
        case .ALWAYS:
            return "Всегда"
        case .NEVER:
            return "Никогда"
        }
    }
}

enum VisibilityParameterType {
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
    
    var requestKey: String {
        switch self {
        case .avatar:
            return "visibility_avatar"
        case .name:
            return "visibility_full_name"
        case .age:
            return "visibility_age"
        }
    }
}

enum NotificationsParameterType {
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
    
    var requestKey: String {
        switch self {
        case .directMessages:
            return "inbound_messages"
        case .liveChat:
            return "live_chat"
        case .tableBookingStatus:
            return "booking_status"
        case .newEvents:
            return "events_and_promo"
        }
    }
}

enum SecurityParameterType {
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

enum ManageAccountSectionType {
    case privacy
    case notification
    case security
    case delete
    
    var title: String {
        switch self {
        case .privacy:
            return "Приватность"
        case .notification:
            return "Уведомления"
        case .security:
            return "Безопастность"
        case .delete:
            return ""
        }
    }
}
