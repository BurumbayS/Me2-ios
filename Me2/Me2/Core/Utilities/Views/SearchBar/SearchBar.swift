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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchIcon: UIImageView!
    
    var searchEndHandler: VoidBlock?
    var searchValue: Dynamic<String> = Dynamic("")
    
    static func instanceFromNib() -> SearchBar {
        return UINib(nibName: "SearchBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SearchBar
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backButton.isHidden = true
        textField.addTarget(self, action: #selector(searchActivated), for: .touchDown)
        textField.addTarget(self, action: #selector(searchValueChanged), for: .editingChanged)
    }
    
    func configure(with textFieldDelegate: UITextFieldDelegate, onSearchEnd: VoidBlock?) {
        self.textField.delegate = textFieldDelegate
        self.searchEndHandler = onSearchEnd
        
        bindDynamics()
    }
    
    private func bindDynamics() {
        searchValue.bind { [weak self] (value) in
            self?.textField.text = value
        }
    }
    
    @objc private func searchValueChanged() {
        if searchValue.value != textField.text {
            searchValue.value = textField.text!
        }
    }
    
    @objc private func searchActivated() {
        textField.becomeFirstResponder()
        
        self.drawShadow(forOpacity: 0.2, forOffset: CGSize(width: 0, height: 0), radius: 3)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Color.gray.cgColor
        
        searchIcon.isHidden = true
        backButton.isHidden = false
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        textField.resignFirstResponder()
        
        searchIcon.isHidden = false
        backButton.isHidden = true
        
        self.drawShadow(forOpacity: 0, forOffset: CGSize(width: 0, height: 0), radius: 0)
        self.layer.borderWidth = 0
        
        searchEndHandler?()
    }
}
