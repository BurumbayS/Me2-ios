//
//  MapSearchFilterViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class MapSearchFilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MapSearchFilterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.filtersSelected.bind { [weak self] (isSelected) in
            self?.navigationItem.leftBarButtonItem?.isEnabled = isSelected
        }
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
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shouldRemoveShadow(true)
        
        navigationItem.title = "Фильтр"
        
        let leftItem = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(discardFilters))
        leftItem.tintColor = Color.red
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.leftBarButtonItem?.isEnabled = viewModel.filtersSelected.value
        
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
        viewModel.configureFiltersData()
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
            if viewModel.selectedFilters.contains(indexPath.row) { selected = true }
            
            let range: SliderRange = (viewModel.filters[indexPath.row] == .business_launch) ? viewModel.businessLaunchRange : viewModel.averageBillRange
            
            cell.configure(with: viewModel.filters[indexPath.row].rawValue, filterType: viewModel.filters[indexPath.row].type, range: range, selected: selected)
            
        case .check:
            
            var selected = false
            if viewModel.selectedFilters.contains(indexPath.row) { selected = true }
            cell.configure(with: viewModel.filters[indexPath.row].rawValue, filterType: viewModel.filters[indexPath.row].type, selected: selected)
            
        case .selectable:
            
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: viewModel.filters[indexPath.row].rawValue, filterType: viewModel.filters[indexPath.row].type)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.filters[indexPath.row].type {
        case .selectable:
            let vc = Storyboard.listForMapFilterViewController() as! ListForMapFilterViewController
            vc.viewModel = ListForMapFilterViewModel(tag_type: viewModel.filters[indexPath.row].tag_type, tag_ids: viewModel.tag_ids)
            vc.title = viewModel.filters[indexPath.row].rawValue
            navigationController?.pushViewController(vc, animated: true)
        default:
            viewModel.selectCell(at: indexPath)
            tableView.reloadData()
        }
    }
}
