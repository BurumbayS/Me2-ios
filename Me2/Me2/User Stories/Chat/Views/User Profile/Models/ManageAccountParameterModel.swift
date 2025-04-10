//
//  ManageAccountCellModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/15/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class ManageAccountParameterModel {
    let title: String
    let type: ManageAccountSectionType
    var notificationParameter: NotificationParameter?
    var visibilityParameter: VisibilityParameter?
    var securityParameterType: SecurityParameterType?
    
    init(title: String, type: ManageAccountSectionType,
         notificationParameter: NotificationParameter? = nil,
         visibilityParameter: VisibilityParameter? = nil,
         securityParameterType: SecurityParameterType? = nil)
    {
        self.title = title
        self.type = type
        self.notificationParameter = notificationParameter
        self.visibilityParameter = visibilityParameter
        self.securityParameterType = securityParameterType
    }
}
