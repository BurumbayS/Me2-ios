//
//  MapSearchFilterViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum FilterType {
    case check
    case slider
    case selectable
}

struct FilterItem {
    var name: String
    var type: FilterType
}

class MapSearchFilterViewModel {
    
    let checkFilterTitles = ["Открыто","Рядом","Круглосуточно","Высокий рейтинг","Наличие событий","Халал"]
    let selectableFilterTitles = ["Тип заведения","Вид кухни","Основное блюдо","Дополнительно"]
    let sliderFilterTitles = ["Средний чек","Бизнес-ланч"]
    var filters = [FilterItem]()
    
    let businessLaunchRange: SliderRange
    let averageBillRange: SliderRange
    
    var selectedCheckFilterIndex: Int?
    var selectedSliderFilterIndex: Int?
    
    init() {
        businessLaunchRange = SliderRange(low: 700, high: 3000)
        averageBillRange = SliderRange(low: 1000, high: 50000)
        
        createCells()
    }
    
    private func createCells() {
        for title in checkFilterTitles {
            let cell = FilterItem(name: title, type: .check)
            filters.append(cell)
        }
        for title in selectableFilterTitles {
            let cell = FilterItem(name: title, type: .selectable)
            filters.append(cell)
        }
        for title in sliderFilterTitles {
            let cell = FilterItem(name: title, type: .slider)
            filters.append(cell)
        }
    }
    
    func selectCell(at indexPath: IndexPath) {
        switch filters[indexPath.row].type {
        case .check:
            selectedCheckFilterIndex = indexPath.row
        case .slider:
            selectedSliderFilterIndex = indexPath.row
        default:
            break
        }
    }
}
