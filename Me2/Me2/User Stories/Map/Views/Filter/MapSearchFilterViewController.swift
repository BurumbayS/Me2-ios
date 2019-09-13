//
//  MapSearchFilterViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class MapSearchFilterViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = MapSearchFilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.registerNib(MapSearchFilterTableViewCell.self)
    }
    
    private func configureNavBar() {
        navBar.isTranslucent = false
        navBar.shouldRemoveShadow(true)
        
        navItem.title = "Фильтр"
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(discardChanges))
        navItem.leftBarButtonItem?.isEnabled = false
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(completeWithFilter))
    }
    
    @objc private func discardChanges() {
        
    }
    
    @objc private func completeWithFilter() {
        dismiss(animated: true, completion: nil)
    }
}

extension MapSearchFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MapSearchFilterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        if viewModel.filters[indexPath.row].type == .selectable { cell.accessoryType = .disclosureIndicator }
        
        switch viewModel.filters[indexPath.row].type {
        case .slider:
            
            var selected = false
            if let index = viewModel.selectedSliderFilterIndex, index == indexPath.row { selected = true }
            
            let range: SliderRange = (viewModel.filters[indexPath.row].name == "Бизнес-ланч") ? viewModel.businessLaunchRange : viewModel.averageBillRange
            
            cell.configure(with: viewModel.filters[indexPath.row].name, filterType: viewModel.filters[indexPath.row].type, range: range, selected: selected)
            
        case .check:
            
            var selected = false
            if let index = viewModel.selectedCheckFilterIndex, index == indexPath.row { selected = true }
            cell.configure(with: viewModel.filters[indexPath.row].name, filterType: viewModel.filters[indexPath.row].type, selected: selected)
            
        case .selectable:
            
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: viewModel.filters[indexPath.row].name, filterType: viewModel.filters[indexPath.row].type)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.filters[indexPath.row].type {
        case .selectable:
            break
        default:
            viewModel.selectCell(at: indexPath)
            tableView.reloadData()
        }
    }
}
