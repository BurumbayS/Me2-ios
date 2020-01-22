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
    let placeholderLabel = UILabel()
    
    var tableSize: Dynamic<CGSize>?
    
    let viewModel = PlaceReviewsViewModel()
    
    var parentVC: UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .updateReviews, object: nil)
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
        placeholderLabel.text = "Пока нет отзывов"
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
        
        tableView.register(PlaceReviewTableViewCell.self)
        tableView.register(ResponseReviewTableViewCell.self)
    }
    
    func configure(itemSize: Dynamic<CGSize>?, placeID: Int, vc: UIViewController) {
        self.tableSize = itemSize
        self.parentVC = vc
        
        viewModel.configure(placeID: placeID)
    }
    
    @objc override func reload () {
        viewModel.fetchData { [weak self] (status, message) in
            switch status {
            case .ok:
                
                if (self?.viewModel.reviews.count)! > 0 {
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
            self.tableSize?.value = (Constants.shared.minContentSize.height < fullTableViewSize.height) ? fullTableViewSize : Constants.shared.minContentSize
            print("Table view reloaded")
            let data = ["tableViewHeight": self.tableView.contentSize.height]
            NotificationCenter.default.post(name: .updateCellheight, object: nil, userInfo: data)
        }
    }
    
    private func deleteReview() {
        viewModel.deleteReview { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.tableView.deleteSections([(self?.viewModel.reviewToDeleteIndex)!], with: .automatic)
            case .error:
                break
            case .fail:
                break
            }
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
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.reviewToDeleteIndex = indexPath.section
            parentVC.addActionSheet(titles: ["Удалить"], actions: [deleteReview], styles: [.destructive])
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.row {
        case 0:
            
            if viewModel.reviews[indexPath.section].user.id == UserDefaults().object(forKey: UserDefaultKeys.userID.rawValue) as! Int {
                return true
            }
            
            return false
            
        default:
            
            return false
        }
    }
}
