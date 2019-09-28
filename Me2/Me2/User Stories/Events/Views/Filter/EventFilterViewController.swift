//
//  EventFilterViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EventFilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.register(TagsTableViewCell.self)
    }
}

extension EventFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "По типу"
        label.font = UIFont(name: "Roboto-Regular", size: 13)
        
        header.addSubview(label)
        constrain(label, header) { label, header in
            label.left == header.left + 20
        }
        
        let line = UIView()
        line.backgroundColor = .lightGray
        header.addSubview(line)
        constrain(line, label, header) { line, label, header in
            line.left == label.right + 10
            line.centerY == label.centerY
            line.height == CGFloat(0.5)
        }
        
        let moreButton = UIButton()
        moreButton.setTitle("См.все", for: .normal)
        moreButton.setTitleColor(Color.red, for: .normal)
        moreButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        
        let btnWidth: CGFloat = 0
        header.addSubview(moreButton)
        constrain(moreButton, line, label, header) { btn, line, label, header in
            btn.left == line.right + 10
            btn.right == header.right - 20
            label.centerY == btn.centerY
            btn.bottom == header.bottom
            btn.height == 20
            btn.width == btnWidth
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: .selectable)
        return cell
    }
}
