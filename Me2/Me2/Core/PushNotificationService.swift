//
//  PushNotificationService.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON
import OneSignal
import UIKit

class PushNotificationService {
    
    static let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
        // This block gets called when the user reacts to a notification received
        let payload: OSNotificationPayload = result!.notification.payload
    
        if payload.additionalData != nil {
            if let universalLink = payload.additionalData["url"] as? String {
                PushNotificationsRouter.shared.shouldPush(to: universalLink)
            }
        }
        
    }
    
    static func subscribeForPushNotifications(by userID: String) {
        if let status = UserDefaults().object(forKey: UserDefaultKeys.notificationsSubscriptionStatus.rawValue) as? Bool {
            if status { return }
        }
        
        let url = Network.host + "/push/token/"
        let token = userID
        let params = ["token": token]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    if json["code"].intValue == 0 {
                        UserDefaults().set(true, forKey: UserDefaultKeys.notificationsSubscriptionStatus.rawValue)
                    }
                    
                case .failure( _):
                    print(JSON(response.data as Any))
                }
        }
    }
}

extension AppDelegate: OSSubscriptionObserver {
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
            // get player ID
            PushNotificationService.subscribeForPushNotifications(by: stateChanges.to.userId)
        }
    }
}
