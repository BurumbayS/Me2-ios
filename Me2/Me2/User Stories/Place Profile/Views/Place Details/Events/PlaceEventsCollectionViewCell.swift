//
//  PlaceEventsCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceEventsCollectionViewCell: PlaceDetailCollectionCell {
    let tableView = TableView()
    let placeholderLabel = UILabel()
    
    var tableSize: Dynamic<CGSize>?
    
    var viewModel = PlaceEventsViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setUpViews()
        configureTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        placeholderLabel.textColor = .darkGray
        placeholderLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        placeholderLabel.text = "Пока нет событий"
        placeholderLabel.isHidden = true
        self.contentView.addSubview(placeholderLabel)
        constrain(placeholderLabel, self.contentView) { label, view in
            label.centerX == view.centerX
            label.top == view.top + 50
        }
        
        self.contentView.addSubview(tableView)
        constrain(tableView, self.contentView) { table, view in
            table.left == view.left
            table.right == view.right
            table.top == view.top
            table.bottom == view.bottom
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.registerNib(EventTableViewCell.self)
    }
    
    func configure(itemSize: Dynamic<CGSize>?, placeID: Int) {
        self.tableSize = itemSize
        
        viewModel.configure(placeID: placeID)
    }
    
    override func reload () {
        viewModel.fetchData { [weak self] (status, message) in
            switch status {
            case .ok:
                
                if (self?.viewModel.events.count)! > 0 {
                    self?.reloadTable()
                    self?.tableView.isHidden = false
                    self?.placeholderLabel.isHidden = true
                } else {
                    self?.tableView.isHidden = true
                    self?.placeholderLabel.isHidden = false
                }

            case .error:
                break
            case .fail:
                break
            }
        }
    }
    
    private func reloadTable() {
        tableView.reloadDataWithCompletion {
            let fullTableViewSize = CGSize(width: self.tableView.contentSize.width, height: self.tableView.contentSize.height + self.tableView.contentInset.bottom)
            self.tableSize?.value = (Constants.minContentSize.height < fullTableViewSize.height) ? fullTableViewSize : Constants.minContentSize
            print("Table view reloaded")
            let data = ["tableViewHeight": self.tableView.contentSize.height]
            NotificationCenter.default.post(name: .updateCellheight, object: nil, userInfo: data)
        }
    }
}

extension PlaceEventsCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
    
        cell.configure(wtih: viewModel.events[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}
