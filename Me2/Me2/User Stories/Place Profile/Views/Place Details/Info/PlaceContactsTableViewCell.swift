//
//  PlaceContactsTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlaceContactsTableViewCell: UITableViewCell {

    var phone: String?
    var instagram: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with phone: String?, ans instagram: String?) {
        self.phone = phone
        self.instagram = instagram
    }
    
    @IBAction func chatButtonPressed(_ sender: Any) {
    }
    
    @IBAction func instagramButtonPressed(_ sender: Any) {
        guard let instaLink = instagram else { return }
        
        if let url = URL(string: instaLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        guard let number = phone?.filter("0123456789+()".contains) else { return }
        
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
