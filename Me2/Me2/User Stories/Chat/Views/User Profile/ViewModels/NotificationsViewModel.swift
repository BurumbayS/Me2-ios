//
//  Т.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/10/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NotificationViewModel {
    
    var notifications = [UserNotification]()
    
    func getNotifications(completion: ResponseBlock?) {
        let url = Network.host + "/push/notification/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    for item in json["data"]["results"].arrayValue {
                        self.notifications.append(UserNotification(json: item))
                    }
                    
                    self.filterNotifications(completion: completion)
                    
                case .failure(_):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    private func filterNotifications(completion: ResponseBlock?) {
        var notificationIDs = [Int]()
        
        if let seenNotificationsIDs = UserDefaults().object(forKey: UserDefaultKeys.seenNotifications.rawValue) as? [Int] {
            for notification in notifications {
                notification.isNew = !seenNotificationsIDs.contains(notification.id)
                notificationIDs.append(notification.id)
            }
        }
        
        UserDefaults().set(notificationIDs, forKey: UserDefaultKeys.seenNotifications.rawValue)
        
        completion?(.ok, "")
    }
    
}
