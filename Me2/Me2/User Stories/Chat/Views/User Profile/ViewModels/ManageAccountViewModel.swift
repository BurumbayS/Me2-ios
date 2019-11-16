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
    var visibilityParameters = [VisibilityParameter]()
    
    init() {
        configureParameters()
    }
    
    private func configureParameters() {
        configureNotificationParameters()
        configureVisibilityParameters()
    }
    
    private func configureNotificationParameters() {
        for type in notificationTypes {
            notificationParameters.append(NotificationParameter(type: type, value: false))
        }
    }
    
    private func configureVisibilityParameters() {
        for type in visibilityTypes {
            visibilityParameters.append(VisibilityParameter(type: type, value: .NEVER))
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
            return ManageAccountParameterModel(title: visibilityTypes[indexPath.row].title, type: .privacy, visibilityParameter: visibilityParameters[indexPath.row])
        case .notification:
            return ManageAccountParameterModel(title: notificationTypes[indexPath.row].title, type: .notification, notificationParameter: notificationParameters[indexPath.row])
        case .security:
            return ManageAccountParameterModel(title: securityTypes[indexPath.row].title, type: .security)
        case .delete:
            return ManageAccountParameterModel(title: "Удалить аккаунт", type: .delete)
        }
    }
    
    func updateData() {
        updateNotificationData { [unowned self] in
            self.updatePrivacyData()
        }
    }
    
    private func updateNotificationData(completion: VoidBlock?) {
        var params = [String: Bool]()
        notificationParameters.forEach { params[$0.type.requestKey] = $0.isOn }
        
        Alamofire.request(updateNotificationDataURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    completion?()
                    
                case .failure(_ ):
                    print("error = \(JSON(response.data as Any))")
                }
        }
    }
    
    private func updatePrivacyData() {
        var params = [String: String]()
        visibilityParameters.forEach { params[$0.type.requestKey] = $0.value.rawValue }
        
        Alamofire.request(updatePrivacyDataURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
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

class VisibilityParameter {
    let type: VisibilityParameterType
    var value: VisibilityStatus
    
    init(type: VisibilityParameterType, value: VisibilityStatus) {
        self.type = type
        self.value = value
    }
}
