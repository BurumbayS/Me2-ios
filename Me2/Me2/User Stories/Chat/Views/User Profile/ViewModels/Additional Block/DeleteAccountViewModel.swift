//
//  DeleteAccountViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/20/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum DeleteReason {
    case ANOTHER_ACCOUNT
    case TAKES_ALOTOF_TIME
    case SECURITY_ISSUES
    case PRIVATE_ISSUES
    case NO_FAV_PLACES
    case NO_PEOPLE
    case DONT_LIKE_APP
    case OTHER
    
    var title: String {
        switch self {
        case .ANOTHER_ACCOUNT:
            return "У меня есть другой профиль"
        case .TAKES_ALOTOF_TIME:
            return "Me2 отнимает слишком много времени"
        case .SECURITY_ISSUES:
            return "Меня беспокоит безопасность моих данных"
        case .PRIVATE_ISSUES:
            return "Личные причины (конфликт, ссора и т.д.)"
        case .NO_FAV_PLACES:
            return "Не нашел(-а) свои любимые заведения"
        case .NO_PEOPLE:
            return "Не нашел(-а) людей для общения"
        case .DONT_LIKE_APP:
            return "Мне не нравится приложение"
        case .OTHER:
            return "Другая причина"
        }
    }
    
    var key: Int {
        switch self {
        case .ANOTHER_ACCOUNT:
            return 1
        case .TAKES_ALOTOF_TIME:
            return 2
        case .SECURITY_ISSUES:
            return 3
        case .PRIVATE_ISSUES:
            return 4
        case .NO_FAV_PLACES:
            return 5
        case .NO_PEOPLE:
            return 6
        case .DONT_LIKE_APP:
            return 7
        case .OTHER:
            return 8
        }
    }
}

class DeleteAccountViewModel {
    let reasons = [DeleteReason.ANOTHER_ACCOUNT, .TAKES_ALOTOF_TIME, .SECURITY_ISSUES, .PRIVATE_ISSUES, .NO_FAV_PLACES, .NO_PEOPLE, .DONT_LIKE_APP, .OTHER]
    var selectedReasonIndex = -1
    var password: Dynamic<String> = Dynamic("")
    var reasonText: Dynamic<String> = Dynamic("")
    
    func deleteAccount(completion: ResponseBlock?) {
        let url = Network.user + "/deactivate/"
        let params = [  "deactivation_types": [reasons[selectedReasonIndex].key],
                        "text": reasonText.value,
                        "password": password.value] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    if json["code"].intValue == 0 {
                        completion?(.ok, "")
                    } else {
                        completion?(.error, json["message"].stringValue)
                    }
                    
                case .failure(_):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
}
