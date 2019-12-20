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
    
    let tagsList = TagsList()
    
    let viewModel = EventFilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        fetchData()
    }
    
    private func fetchData() {
        viewModel.getFilters { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadSections([0,1,2,3], with: .automatic)
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shouldRemoveShadow(true)
        
        navigationItem.title = "Фильтр"
        
        let leftItem = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(discardFilters))
        leftItem.tintColor = Color.red
        navigationItem.leftBarButtonItem = leftItem
//        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let rightItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(completeWithFilter))
        rightItem.tintColor = Color.blue
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func discardFilters() {
        viewModel.discardFilters { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func completeWithFilter() {
        dismiss(animated: true, completion: nil)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.backgroundColor = .white
        
        tableView.register(TagsTableViewCell.self)
        tableView.registerNib(EventSliderFilterTableViewCell.self)
    }
}

extension EventFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .white
        
        let label = UILabel()
        label.textColor = .lightGray
        label.text = viewModel.filterTypes[section].title
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
        
        let btnWidth: CGFloat = (viewModel.shouldShowMore(forSection: section)) ? 60 : 0
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
        return viewModel.filterTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = viewModel.filterTypes[indexPath.section]
        switch type {
        case .PRICE:
            
            let cell: EventSliderFilterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
            
        default:
            
            let cell: TagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(tagsType: .selectable, tagsList: TagsList(items: viewModel.getVisibleTagsList(ofType: type)))
            return cell
            
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.tagsList.selectedList)
    }
}
