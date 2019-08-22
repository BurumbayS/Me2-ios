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
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enableScroll), name: .makeTableViewScrollable, object: nil)
        setUpViews()
        configureTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
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
        tableView.isScrollEnabled = false
        
        tableView.register(SampleTableViewCell.self)
    }
    
    @objc private func enableScroll() {
        tableView.isScrollEnabled = true
    }
}

extension PlaceInfoCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SampleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.configure(with: indexPath.row)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Table view offset \(tableView.contentOffset.y)")
        
        //stop scrolling table if it reach the top
        if tableView.contentOffset.y < 0 {
            tableView.isScrollEnabled = false
            NotificationCenter.default.post(.init(name: .makeCollectionViewScrollable))
            print(tableView.contentSize)
        }
    }
}
