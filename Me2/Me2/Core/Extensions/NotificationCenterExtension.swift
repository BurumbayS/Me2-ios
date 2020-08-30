//
//  NotificationCenterExtension.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/20/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let makeTableViewScrollable = Notification.Name("makeTableViewScrollable")
    static let makeCollectionViewScrollable = Notification.Name("makeCollectionViewScrollable")
    static let updateCellheight = Notification.Name("updateCellheight")
    static let updateReviews = Notification.Name("updateReviews")
    static let openChatOnPush = Notification.Name("openChatOnPush")
    static let updateFavouriteEvents = Notification.Name("updateFavouriteEvents")
}
