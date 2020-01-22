//
//  EventFilterViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/19/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum EventFilterType: String {
    case EVENT
    case INTERESTS
    case PRICE
    case DATE_TIME
    
    var title: String {
        switch self {
        case .EVENT:
            return "По типу"
        case .DATE_TIME:
            return "По дате и времени"
        case .INTERESTS:
            return "По интересам"
        case .PRICE:
            return "Цена"
        }
    }
}

class EventFilterViewModel {
    
    var filterTypes = [EventFilterType.EVENT, .DATE_TIME, .INTERESTS, .PRICE]
    var filters = [String: [Tag]]() {
        didSet {
            if self.filters.count == filterTypes.count {
                self.dataLoaded = true
            }
        }
    }
    var tagsLists = [String: TagsList]()
    var tagIDsToSearch: Dynamic<[Int]>!
    
    var filtersLoadCompletion: VoidBlock?
    
    var dataLoaded: Bool = false {
        didSet {
            if self.dataLoaded {
                self.filtersLoadCompletion?()
            }
        }
    }
    
    init(tagIDsToSearch: Dynamic<[Int]>) {
        self.tagIDsToSearch = tagIDsToSearch
    }
    
    func discardFilters(completion: VoidBlock?) {
        for tagsList in tagsLists {
            tagsList.value.selectedList = []
        }
        
        tagIDsToSearch.value = []
        
        completion?()
    }
    
    func shouldShowMore(forSection section: Int) -> Bool {
        
        if let tags = filters[filterTypes[section].rawValue], tags.count > 5 {
            return true
        }
        
        return false
    }
    
    func getFilters(completion: VoidBlock?) {
        self.filtersLoadCompletion = completion
        
        for filterType in filterTypes {
            loadFilters(ofType: filterType) { [weak self] (tags) in
                self?.addTagsList(with: tags, to: filterType)
                self?.filters[filterType.rawValue] = tags
            }
        }
    }
    
    func getVisibleTagsList(ofType type: EventFilterType) -> [String] {
        switch type {
        case .EVENT, .INTERESTS:
            
            var visibleTags = [String]()
            for tag in filters[type.rawValue]?.prefix(5) ?? [] {
                visibleTags.append(tag.name)
            }
            
            return visibleTags
            
        default:
            return []
        }
    }
    
    func completeTagsChoice(completion: VoidBlock?) {
        var tagIDs = [Int]()
        for tagsList in tagsLists {
            for item in tagsList.value.selectedList {
                if let id = getSelectedTagID(for: item) {
                    tagIDs.append(id)
                }
            }
        }
        
        tagIDsToSearch.value = tagIDs
        completion?()
    }
    
    private func getSelectedTagID(for tagName: String) -> Int? {
        for filter in filterTypes {
            if let tag = filters[filter.rawValue]?.first(where: { $0.name == tagName }) {
                return tag.id
            }
        }
        
        return nil
    }
    
    private func loadFilters(ofType type: EventFilterType, completion: (([Tag]) -> Void)?) {
        let url = Network.core + "/tag/?tag_type=\(type.rawValue)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    var tags = [Tag]()
                    for item in json["data"].arrayValue {
                        tags.append(Tag(json: item))
                    }
                    
                    completion?(tags)
                    
                case .failure(_):
                    print(JSON(response.data as Any))
                    completion?([])
                }
        }
    }
    
    private func addTagsList(with tags: [Tag], to filterType: EventFilterType) {
        var items = [String]()
        var selectedItems = [String]()
        
        for tag in tags {
            items.append(tag.name)
            if tagIDsToSearch.value.contains(where: { $0 == tag.id }) {
                selectedItems.append(tag.name)
            }
        }
        
        tagsLists[filterType.rawValue] = TagsList(items: items, selectedItems: selectedItems)
    }
}
