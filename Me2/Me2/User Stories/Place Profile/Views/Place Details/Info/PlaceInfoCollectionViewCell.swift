//
//  PlaceInfoCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceInfoCollectionViewCell: PlaceDetailCollectionCell {
    
    let tableView = TableView()
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
    
    func configure(itemSize: Dynamic<CGSize>?) {
        self.tableSize = itemSize
    }
    
    override func reload () {
        tableView.reloadDataWithCompletion {
            let fullTableViewSize = CGSize(width: self.tableView.contentSize.width, height: self.tableView.contentSize.height + self.tableView.contentInset.bottom)
            self.tableSize?.value = (Constants.minContentSize.height < fullTableViewSize.height) ? fullTableViewSize : Constants.minContentSize
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
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        tableView.register(PlaceDescriptionTableViewCell.self)
        tableView.registerNib(PlaceContactsTableViewCell.self)
        tableView.register(AdressTableViewCell.self)
        tableView.register(PlaceWorkTimeTableViewCell.self)
        tableView.register(MailSiteTableViewCell.self)
        tableView.register(TagsTableViewCell.self)
        tableView.register(PlaceSubsidiariesTableViewCell.self)
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
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            let cell: PlaceDescriptionTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: "Кофейни «Traveler`s Coffee» совмещают в себе концепцию приятного дизайна заведений с демократичным и весьма современным стилем") { [weak self] in
                self?.tableView.beginUpdates()
                    cell.updateUI()
                self?.tableView.endUpdates()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self?.reload()
                })
            }
            return cell
            
        case 1:
            
            let cell: PlaceContactsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            return cell
            
        case 2:
            
            let cell: AdressTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: "Желтоксана, 137", additionalInfo: "1 этаж, Алмалинский район", distance: "1.3 км")
            return cell
            
        case 3:
            
            let cell: PlaceWorkTimeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: "Ежедневно 08:00 - 24:00", and: "Закроется через 20 мин", isOpen: true)
            return cell
            
        case 4:
            
            let cell: MailSiteTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(withEmail: "travelers@coffee.com")
            return cell
            
        case 5:
            
            let cell: MailSiteTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(withWebSite: "www.travelers-coffee.com")
            return cell
            
        case 6:
            
            let cell: TagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            return cell
            
        case 7:
            
            let cell: PlaceSubsidiariesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: 3)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
