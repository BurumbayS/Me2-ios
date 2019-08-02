//
//  SearchBar.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class SearchBar: UIView {

    @IBOutlet weak var textField: UITextField!
    
    static func instanceFromNib() -> SearchBar {
        return UINib(nibName: "SearchBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SearchBar
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.addTarget(self, action: #selector(searchActivated), for: .touchUpInside)
    }
    
    @objc private func searchActivated() {
        textField.becomeFirstResponder()
        print("searchActivated")
    }
    
    @IBAction func dictationPressed(_ sender: Any) {
        
    }
}
