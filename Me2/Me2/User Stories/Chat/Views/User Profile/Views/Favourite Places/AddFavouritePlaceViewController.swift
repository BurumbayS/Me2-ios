//
//  AddFavouritePlaceViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Cartography

class AddFavouritePlaceViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: AddFavouritePlaceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        addDismissKeyboard()
        configureTableView()
        configureSearchBar()
        bindDynamics()
    }
    
    private func bindDynamics() {
        viewModel.updateSearchResults.bind { [weak self] (value) in
            self?.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navBar.shouldRemoveShadow(true)
        
        navItem.title = "Добавить"
        setUpBackBarButton(for: navItem)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.registerNib(PlaceTableViewCell.self)
    }
    
    private func add(place: Place) {
        viewModel.currentFavouritePlaces.append(place)
        tableView.reloadData()
        
        viewModel.addPlaceToFavourite(with: place.id) { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.viewModel.addPlacehandler?(place)
            case .error:
                self?.viewModel.currentFavouritePlaces.removeAll(where: { $0.id == place.id })
            case .fail:
                self?.viewModel.currentFavouritePlaces.removeAll(where: { $0.id == place.id })
            }
            
            self?.tableView.reloadData()
        }
    }
}

extension AddFavouritePlaceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        
        let place = viewModel.searchResults[indexPath.row]
        let added = viewModel.currentFavouritePlaces.contains(where: { $0.id == place.id })
        cell.configure(with: viewModel.searchResults[indexPath.row], cellType: .toAdd, added: added, onAdd: { [weak self] in
            self?.add(place: place)
        })
        
        return cell
    }
}

extension AddFavouritePlaceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchValue.value = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
