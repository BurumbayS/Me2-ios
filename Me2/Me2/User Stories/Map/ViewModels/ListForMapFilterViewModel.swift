//
//  ListForMapFilterViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/21/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ListForMapFilterViewModel {
    let tag_ids: Dynamic<[Int]>
    let tag_type: String
    var tags = [Tag]()
    
    init(tag_type: String, tag_ids: Dynamic<[Int]>) {
        self.tag_ids = tag_ids
        self.tag_type = tag_type
    }
    
    func fetchData(completion: ResponseBlock?) {
        let url = tagsListURL + tag_type
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.tags = []
                    for item in json["data"].arrayValue {
                        self.tags.append(Tag(json: item))
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    func selectTag(at indexPath: IndexPath) {
        if let index = tag_ids.value.firstIndex(of: tags[indexPath.row].id) {
            tag_ids.value.remove(at: index)
        } else {
            tag_ids.value.append(tags[indexPath.row].id)
        }
    }
    
    let tagsListURL = Network.core + "/tag/?tag_type="
}
