//
//  LiveChatViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/7/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON
import Alamofire

class LiveChatViewModel {
    let room: Room
    var notificationsIsOn = true
    private var notificationData: JSON!
    
    init(room: Room) {
        self.room = room
        
        getNotificationStatus()
    }
    
    private func getNotificationStatus() {
        guard let userInfoJSONString = UserDefaults().object(forKey: UserDefaultKeys.userInfo.rawValue) as? String else { return }
        
        let userJSON = JSON(parseJSON: userInfoJSONString)
        notificationData = userJSON["notification_data"]
        notificationsIsOn = notificationData[NotificationsParameterType.liveChat.requestKey].boolValue
    }
    
    func editNotifications() {
        var newNotificationsData = [String: Bool]()
        for item in notificationData.dictionaryValue {
            newNotificationsData[item.key] = item.value.boolValue
        }
        newNotificationsData[NotificationsParameterType.liveChat.requestKey] = !notificationsIsOn
        
        Alamofire.request(updateNotificationDataURL, method: .put, parameters: newNotificationsData, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    if json["code"].intValue == 0 {
                        let userJSON = json["data"]["user"]
                        UserDefaults().set(userJSON.rawString(), forKey: UserDefaultKeys.userInfo.rawValue)
                        self.notificationsIsOn = !self.notificationsIsOn
                    }
                    
                case .failure(_ ):
                    print("error = \(JSON(response.data as Any))")
                }
        }
    }
    
    let updateNotificationDataURL = Network.user + "/update_notification_data/"
}
