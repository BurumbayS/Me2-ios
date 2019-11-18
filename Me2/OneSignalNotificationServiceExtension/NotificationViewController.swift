//
//  NotificationViewController.swift
//  OneSignalNotificationServiceExtension
//
//  Created by Sanzhar Burumbay on 11/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

}
