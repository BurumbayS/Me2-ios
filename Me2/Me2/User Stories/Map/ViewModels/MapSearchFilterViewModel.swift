//
//  MapSearchFilterViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

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
    var businessLaunchRange: SliderRange!
    var averageBillRange: SliderRange!
    
    let checkFilterTitles = ["Открыто","Рядом","Круглосуточно","Высокий рейтинг","Наличие событий","Халал"]
    let selectableFilterTitles = ["Тип заведения","Вид кухни","Основное блюдо","Дополнительно"]
    let sliderFilterTitles = ["Средний чек","Бизнес-ланч"]
    
    var filters = [Filter]()
    var tag_ids: Dynamic<[Int]>
    
    var selectedFilters = [Int]()
    var filtersSelected: Dynamic<Bool>!
    
    var filtersData: Dynamic<[FilterData]>
    
    init(filtersData: Dynamic<[FilterData]>) {
        self.filtersData = filtersData
        self.tag_ids = Dynamic([])
        
        createCells()
        configureFilters()
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
    
    private func configureFilters() {
        for (i, filter) in filters.enumerated() {
            if filtersData.value.contains(where: { $0.key == filter.key }) {
                selectedFilters.append(i)
            }
        }
        
        if let filter = filtersData.value.first(where: { $0.key == "tag_ids" }) {
            tag_ids.value = filter.value as! [Int]
        }
        
        if filtersData.value.contains(where: { $0.key == "average_check_min" }) {
            let min = filtersData.value.first(where: { $0.key == "average_check_min" })?.value as! CGFloat
            let max = filtersData.value.first(where: { $0.key == "average_check_max" })?.value as! CGFloat
            
            averageBillRange = SliderRange(low: min, high: max)
            let index = filters.firstIndex(of: .average_bill)
            selectedFilters.append(index!)
        } else {
            averageBillRange = SliderRange(low: 1000, high: 50000)
        }
        
        if filtersData.value.contains(where: { $0.key == "business_launch_min" }) {
            let min = filtersData.value.first(where: { $0.key == "business_launch_min" })?.value as! CGFloat
            let max = filtersData.value.first(where: { $0.key == "business_launch_max" })?.value as! CGFloat
            
            businessLaunchRange = SliderRange(low: min, high: max)
            let index = filters.firstIndex(of: .business_launch)
            selectedFilters.append(index!)
        } else {
            businessLaunchRange = SliderRange(low: 700, high: 3000)
        }
        
        filtersSelected = (selectedFilters.count > 0) ? Dynamic(true) : Dynamic(false)
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
                
                data.append(FilterData(key: "latitude", value: Location.my.coordinate.latitude))
                data.append(FilterData(key: "longitude", value: Location.my.coordinate.longitude))
            
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
