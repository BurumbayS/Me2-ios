//
//  BookTableViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum BookingParameterType: String {
    case dateTime = "Дата и время"
    case numberOfGuest = "Количество гостей"
    case username = "Бронь на имя"
    case phoneNumber = "Телефон"
    case wishes = "Пожелания к брони"
}

class BookingParameter {
    let type: BookingParameterType
    var filledCorrectly: Dynamic<Bool>!
    var data: Any!
    var callback = false
    var remember = false
    var guests = [String]()
    
    init(type: BookingParameterType) {
        self.type = type
        self.filledCorrectly = (type == .wishes) ? Dynamic(true) : Dynamic(false)
    }
}

class BookTableViewModel {
    let bookingParameters: [BookingParameter] = [BookingParameter(type: .dateTime), BookingParameter(type: .numberOfGuest), BookingParameter(type: .username), BookingParameter(type: .phoneNumber), BookingParameter(type: .wishes)]
    
    let placeID: Int
    
    init(placeID: Int) {
        self.placeID = placeID
    }
    
    private func fieldsFilledCorreclty() -> Bool {
        var filledCorrectly = true
        
        for parameter in bookingParameters {
            if parameter.filledCorrectly.value == false {
                filledCorrectly = false
                parameter.filledCorrectly.value = false
            }
        }
        
        return filledCorrectly
    }
    
    func bookTable(completion: ResponseBlock?) {
        if !fieldsFilledCorreclty() { return }
        
        var params = ["place" : placeID] as [String : Any]
        for parameter in bookingParameters {
            switch parameter.type {
            case .dateTime:
                params["date"] = parameter.data
            case .numberOfGuest:
                params["amount"] = parameter.data
            case .phoneNumber:
                params["booker_phone"] = parameter.data
                params["callback"] = parameter.callback
            case .username:
                params["booker_name"] = parameter.data
            case .wishes:
                params["comment"] = parameter.data
            }
        }
        
        Alamofire.request(bookTableURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.error, "")
                }
        }
    }
    
    let bookTableURL = Network.core + "/booking/"
}
