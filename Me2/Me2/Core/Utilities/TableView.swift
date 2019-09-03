//
//  TableView.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/22/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class TableView: UITableView {
    private var reloadDataCompletionBlock: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        reloadDataCompletionBlock = completion
        self.reloadData()
    }
}
