//
//  PlaceInfoCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceInfoCollectionViewCell: UICollectionViewCell {
    
    let tableView = TableView()
    var cellsCount = 0
    var tableSize: Dynamic<CGSize>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enableScroll), name: .makeTableViewScrollable, object: nil)
        setUpViews()
        configureTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellsCount: Int, itemSize: Dynamic<CGSize>?) {
        self.cellsCount = cellsCount
        self.tableSize = itemSize
    }
    
    func reload () {
        tableView.reloadDataWithCompletion {
            self.tableSize?.value = (Constants.minContentSize.height < self.tableView.contentSize.height) ? self.tableView.contentSize : Constants.minContentSize
            print("Table view reloaded")
            let data = ["tableViewHeight": self.tableView.contentSize.height]
            NotificationCenter.default.post(name: .updateCellheight, object: nil, userInfo: data)
        }
    }
    
    private func setUpViews() {
        self.contentView.addSubview(tableView)
        configureViews()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.isScrollEnabled = false
        
        tableView.register(SampleTableViewCell.self)
    }
    
    @objc private func enableScroll() {
        tableView.isScrollEnabled = true
    }
    
    private func configureViews() {
        constrain(tableView, self.contentView) { table, view in
            table.left == view.left
            table.right == view.right
            table.top == view.top
            table.bottom == view.bottom
        }
    }
}

extension PlaceInfoCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SampleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.configure(with: indexPath.row)
        return cell
    }
}
