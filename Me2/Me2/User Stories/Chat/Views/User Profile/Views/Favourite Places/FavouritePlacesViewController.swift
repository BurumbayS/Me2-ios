//
//  FavouritePlacesViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/12/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class FavouritePlacesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var viewModel: FavouritePlacesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTabeView()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navBar.isTranslucent = false
        navItem.title = "Любимые места"
        
        setUpBackBarButton(for: navItem)
        
        if viewModel.isEditable {
            let rightItem = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addPlace))
            rightItem.tintColor = Color.blue
            navItem.rightBarButtonItem = rightItem
        }
    }
    
    private func configureTabeView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double(Float.leastNormalMagnitude)))
        
        tableView.registerNib(PlaceTableViewCell.self)
    }
    
    @objc private func addPlace() {
        let vc = Storyboard.addFavouritePlaceViewController() as! AddFavouritePlaceViewController
        vc.viewModel = AddFavouritePlaceViewModel(favouritePlaces: viewModel.favouritePlaces.value, onAddPlace: { [weak self] (place) in
            self?.viewModel.favouritePlaces.value.append(place)
            self?.tableView.reloadSections([0], with: .automatic)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func removePlace() {
        if let indexPath = viewModel.toDeletePlaceIndexPath {
            viewModel.removeFromFavourite(place: viewModel.favouritePlaces.value[indexPath.row]) { [weak self] (status, message) in
                switch status {
                case .ok:
                    self?.viewModel.favouritePlaces.value.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                case .error:
                    break
                case .fail:
                    break
                }
            }
        }
    }
}

extension FavouritePlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favouritePlaces.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: viewModel.favouritePlaces.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.isEditable
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            viewModel.toDeletePlaceIndexPath = indexPath
            addActionSheet(titles: ["Удалить"], actions: [removePlace], styles: [.destructive])
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.placeProfileViewController() as! PlaceProfileViewController
        vc.viewModel = PlaceProfileViewModel(place: viewModel.places[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
