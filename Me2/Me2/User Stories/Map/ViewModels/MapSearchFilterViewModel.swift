//
//  MapSearchFilterViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum Filter: String {
    case open_now = "Открыто"
    case nearby = "Рядом"
    case day_n_night = "Круглосуточно"
    case high_rating = "Высокий рейтинг"
    case events_presents = "Наличие событий"
    case halal = "Халал"
    case place_type = "Тип заведения"
    case kithen_type = "Вид кухни"
    case main_dish = "Основное блюдо"
    case extra = "Дополнительно"
    case average_bill = "Средний чек"
    case business_launch = "Бизнес-ланч"
    
    var type: FilterType {
        switch self {
        case .open_now, .nearby, .day_n_night, .high_rating, .events_presents, .halal:
            return .check
        case .place_type, .kithen_type, .main_dish, .extra:
            return .selectable
        case .average_bill, .business_launch:
            return .slider
        }
    }
    
    var key: String {
        switch self {
        case .open_now:
            return "open_now"
        case .nearby:
            return "nearby"
        case .day_n_night:
            return "day_and_night"
        case .high_rating:
            return "ordering"
        case .events_presents:
            return "events_count__gt"
        case .halal:
            return "halal"
        default:
            return ""
        }
    }
    
    var value: Any {
        switch self {
        case .open_now:
            return true
        case .nearby:
            return "nearby"
        case .day_n_night:
            return "day_and_night"
        case .high_rating:
            return "ordering"
        case .events_presents:
            return "events_count__gt"
        case .halal:
            return "halal"
        default:
            return ""
        }
    }
    
    var tag_type: String {
        switch self {
        case .place_type:
            return "PLACE_TYPE"
        case .main_dish:
            return "DISH"
        case .kithen_type:
            return "KITCHEN"
        case .extra:
            return "EXTRA"
        default:
            return ""
        }
    }
}

enum FilterType {
    case check
    case slider
    case selectable
}

class MapSearchFilterViewModel {
    let businessLaunchRange: SliderRange
    let averageBillRange: SliderRange
    
    let checkFilterTitles = ["Открыто","Рядом","Круглосуточно","Высокий рейтинг","Наличие событий","Халал"]
    let selectableFilterTitles = ["Тип заведения","Вид кухни","Основное блюдо","Дополнительно"]
    let sliderFilterTitles = ["Средний чек","Бизнес-ланч"]
    
    var filters = [Filter]()
    var tag_ids: Dynamic<[Int]>
    
    var selectedFilters = [Int]()
    var filtersSelected: Dynamic<Bool>
    
    var filtersData: Dynamic<[FilterData]>
    
    init(filtersData: Dynamic<[FilterData]>) {
        self.filtersData = filtersData
        tag_ids = Dynamic([])
        
        businessLaunchRange = SliderRange(low: 700, high: 3000)
        averageBillRange = SliderRange(low: 1000, high: 50000)
        filtersSelected = Dynamic(false)
        
        createCells()
    }
    
    private func createCells() {
        for title in checkFilterTitles {
            filters.append(Filter(rawValue: title)!)
        }
        for title in selectableFilterTitles {
            filters.append(Filter(rawValue: title)!)
        }
        for title in sliderFilterTitles {
            filters.append(Filter(rawValue: title)!)
        }
    }
    
    func selectCell(at indexPath: IndexPath) {
        switch filters[indexPath.row].type {
        case .check, .slider:
            if let index = selectedFilters.firstIndex(of: indexPath.row) {
                selectedFilters.remove(at: index)
            } else {
                selectedFilters.append(indexPath.row)
            }
        default:
            break
        }
        
        
        filtersSelected.value = selectedFilters.count > 0
    }
    
    func discardFilters(completion: VoidBlock?) {
        selectedFilters = []
        
        filtersSelected.value = false
        
        completion?()
    }
    
    func configureFiltersData() {
        var data = [FilterData]()
        
        for index in selectedFilters {
            switch filters[index] {
            case .average_bill:
                
                data.append(FilterData(key: "average_check_min", value: averageBillRange.low))
                data.append(FilterData(key: "average_check_max", value: averageBillRange.high))
                
            case .business_launch:
                
                data.append(FilterData(key: "business_lunch_min", value: businessLaunchRange.low))
                data.append(FilterData(key: "business_lunch_max", value: businessLaunchRange.high))
                
            case .open_now, .day_n_night, .halal:
                
                let selected = selectedFilters.contains(index)
                data.append(FilterData(key: filters[index].key, value: selected))
                
            case .nearby:
                
                break
            
            case .high_rating:
                
                data.append(FilterData(key: "ordering", value: "-rating"))
                
            case .events_presents:
                
                data.append(FilterData(key: "events_count__gt", value: "0"))
                
            default:
                break

            }
        }
        
        if tag_ids.value.count > 0 { data.append(FilterData(key: "tag_ids", value: tag_ids.value)) }
        
        filtersData.value = data
    }
}
