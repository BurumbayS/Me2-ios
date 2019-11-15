//
//  ManageAccountViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ManageAccountViewModel {
    let sections = [ManageAccountSectionType.privacy, .notification, .security, .delete]
    let visibilityTypes = [VisibilityParameterType.avatar, .name, .age]
    let notificationTypes = [NotificationsParameterType.directMessages, .liveChat, .tableBookingStatus, .newEvents]
    let securityTypes = [SecurityParameterType.changePassword, .changePhoneNumber, .accessCode]
    
    var notificationParameters = [NotificationParameter]()
    
    init() {
        configureParameters()
    }
    
    private func configureParameters() {
        configureNotificationParameters()
    }
    
    private func configureNotificationParameters() {
        for type in notificationTypes {
            notificationParameters.append(NotificationParameter(type: type, value: false))
        }
    }
    
    func cellsCount(for section: Int) -> Int {
        let type = sections[section]
        
        switch type {
        case .privacy:
            return visibilityTypes.count
        case .notification:
            return notificationTypes.count
        case .security:
            return securityTypes.count
        case .delete:
            return 1
        }
    }
    
    func modelForCell(at indexPath: IndexPath) -> ManageAccountParameterModel {
        switch sections[indexPath.section] {
        case .privacy:
            return ManageAccountParameterModel(title: visibilityTypes[indexPath.row].title, type: .privacy)
        case .notification:
            return ManageAccountParameterModel(title: notificationTypes[indexPath.row].title, type: .notification, notificationParameter: notificationParameters[indexPath.row])
        case .security:
            return ManageAccountParameterModel(title: securityTypes[indexPath.row].title, type: .security)
        case .delete:
            return ManageAccountParameterModel(title: "Удалить аккаунт", type: .delete)
        }
    }
    
    func updateNotificationData() {
        var params = [String: Bool]()
        notificationParameters.forEach { params[$0.type.requestKey] = $0.isOn }
        
        Alamofire.request(updateNotificationDataURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure(_ ):
                    print("error = \(JSON(response.data as Any))")
                }
        }
    }
    
    let updateNotificationDataURL = Network.user + "/update_notification_data/"
    let updatePrivacyDataURL = Network.user + "/update_privacy_data/"
}

class NotificationParameter {
    let type: NotificationsParameterType
    var isOn: Bool
    
    init(type: NotificationsParameterType, value: Bool) {
        self.type = type
        self.isOn = value
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
