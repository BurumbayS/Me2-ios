//
//  ListContainedViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/8/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ListContainedViewController: UIViewController {
    
    let emptyListStatusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmptyListStatusLabel()
    }
    
    private func setupEmptyListStatusLabel() {
        emptyListStatusLabel.isHidden = true
        emptyListStatusLabel.textColor = .darkGray
        emptyListStatusLabel.textAlignment = .center
        emptyListStatusLabel.numberOfLines = 0
        emptyListStatusLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        self.view.addSubview(emptyListStatusLabel)
        constrain(emptyListStatusLabel, self.view) { label, view in
            label.centerX == view.centerX
            label.centerY == view.centerY - 50
            label.width == 200
        }
    }
    
    func showEmptyListStatusLabel(withText text: String) {
        emptyListStatusLabel.text = text
        emptyListStatusLabel.isHidden = false
    }

    func hideEmptyListStatusLabel() {
        emptyListStatusLabel.isHidden = true
    }
}
