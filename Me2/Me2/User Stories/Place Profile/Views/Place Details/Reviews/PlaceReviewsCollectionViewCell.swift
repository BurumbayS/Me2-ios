//
//  PlaceReviewsCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceReviewsCollectionViewCell: PlaceDetailCollectionCell {
    let tableView = TableView()
    
    var tableSize: Dynamic<CGSize>?
    
    let viewModel = PlaceReviewsViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .updateReviews, object: nil)
        
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
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.register(PlaceReviewTableViewCell.self)
        tableView.register(ResponseReviewTableViewCell.self)
    }
    
    func configure(itemSize: Dynamic<CGSize>?, placeID: Int) {
        self.tableSize = itemSize
        
        viewModel.configure(placeID: placeID)
    }
    
    @objc override func reload () {
        viewModel.fetchData { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.reloadTable()
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

extension PlaceReviewsCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.reviews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.reviews[section].responses.count > 0) ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            let cell: PlaceReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.configure(with: viewModel.reviews[indexPath.section])
            cell.selectionStyle = .none
            
            return cell
            
        default:
            
            let cell: ResponseReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.configure(with: viewModel.reviews[indexPath.section].responses[0])
            cell.selectionStyle = .none
            
            return cell
        }
    }
}
