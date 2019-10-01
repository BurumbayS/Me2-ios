//
//  BookTableViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum BookingParameters: String {
    case dateTime = "Дата и время"
    case numberOfGuest = "Количество гостей"
    case username = "Бронь на имя"
    case phoneNumber = "Телефон"
    case wishes = "Пожелания к брони"
}

class BookTableViewModel {
    let bookingParameters = [BookingParameters.dateTime, .numberOfGuest, .username, .phoneNumber, .wishes]
}
