//
//  Event.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON
import Alamofire

enum DateType: String {
    case weekdays = "WEEKDAYS"
    case everyday = "EVERYDAY"
    case once = "ONCE"
    
    var title: String {
        switch self {
        case .weekdays:
            return "Будни"
        case .everyday:
            return "Ежедневно"
        case .once:
            return ""
        }
    }
}

class Event {
    let id: Int
    var title: String!
    var description: String?
    var imageURL: String?
    var place: Place!
    var flagImage = UIImage(named: "unselected_flag")
    var eventType: String!
    var start: String!
    var end: String!
    var time_start: String?
    var time_end: String?
    var date_type: DateType!
    var tags = [String]()
    var isFavourite: Dynamic<Bool>
    var json = JSON()
    
    init(json: JSON) {
        self.json = json
        
        id = json["id"].intValue
        title = json["name"].stringValue
        description = json["description"].stringValue
        isFavourite = Dynamic(json["is_favourite"].boolValue)
        imageURL = json["image"].stringValue
        eventType = json["event_type"]["name"].stringValue
        place = Place(json: json["place"])
        date_type = DateType(rawValue: json["date_type"].stringValue)
        start = json["start"].stringValue
        end = json["end"].stringValue
        time_start = json["time_start"].stringValue
        time_end = json["time_end"].stringValue
        
        for item in json["tags"].arrayValue {
            tags.append(item.stringValue)
        }
        
        bindDynamics()
    }
    
//    func toJSON() -> JSON {
//        
//    }
    
    private func bindDynamics() {
        isFavourite.bindAndFire({ (status) in
            self.flagImage = (status) ? UIImage(named: "selected_flag") : UIImage(named: "unselected_flag")
        })
    }
    
    func getTime() -> String {
        if date_type == .once {
            return "\(formatDate(str: start))-\(formatDate(str: end))"
        }
        
        var start = time_start ?? ""
        var end = time_end ?? ""
        
        if start != "" && end != "" {
            start.removeLast(3)
            end.removeLast(3)
            
            return date_type.title + " " + start + "-" + end
        }
        
        if end != "" {
            end.removeLast(3)

            return date_type.title + " до " + end
        }
        
        if start != "" {
            start.removeLast(3)
            
            return date_type.title + " с " + start
        }
        
        return date_type.title
    }
    
    private func formatDate(str: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: str)
        
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date!)
    }
    
    func changeFavouriteStatus(completion: ResponseBlock?) {
        self.isFavourite.value ? addToFavourite(completion: completion) : removeFromFavourite(completion: completion)
    }
    
    private func addToFavourite(completion: ResponseBlock?) {
        let url = Network.core + "/event/\(self.id)/add_favourite/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    self.json["is_favourite"] = true
     
                    if let savedEventsString = UserDefaults().object(forKey: UserDefaultKeys.savedEvents.rawValue) as? String {
                        var json = JSON(parseJSON: savedEventsString)
                        json.arrayObject?.append(self.json)
                        
                        UserDefaults().set(json.rawString(), forKey: UserDefaultKeys.savedEvents.rawValue)
                        NotificationCenter.default.post(name: .updateFavouriteEvents, object: nil)
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    private func removeFromFavourite(completion: ResponseBlock?) {
        let url = Network.core + "/event/\(self.id)/remove_favourite/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    if let savedEventsString = UserDefaults().object(forKey: UserDefaultKeys.savedEvents.rawValue) as? String {
                        var json = JSON(parseJSON: savedEventsString)
                        
                        for (i, event) in json.arrayValue.enumerated() {
                            if event["id"].intValue == self.json["id"].intValue {
                                json.arrayObject?.remove(at: i)
                                break
                            }
                        }
                        
                        UserDefaults().set(json.rawString(), forKey: UserDefaultKeys.savedEvents.rawValue)
                        NotificationCenter.default.post(name: .updateFavouriteEvents, object: nil)
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    func generateShareInfo() -> String {
        var message = ""
        
        message =   "\(title!) в \(place.name ?? "")\n" +
                    "\(getTime())" +
                    "\n" +
                    "\n" +
                    "Для просмотра подробной информации откройте в приложении Me2" +
                    "\n" +
                    "\n" +
                    "Доступно бесплатно в:\n" +
                    "App store: www.me2.kz\n" +
                    "Google play: www.me2.kz"
        
        return message
    }
}
