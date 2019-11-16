//
//  FavouritePlacesViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/12/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import SwiftyJSON

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
        
        let rightItem = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addPlace))
        rightItem.tintColor = Color.blue
        navItem.rightBarButtonItem = rightItem
    }
    
    private func configureTabeView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double(Float.leastNormalMagnitude)))
        
        tableView.registerNib(PlaceTableViewCell.self)
    }
    
    @objc private func addPlace() {
//        UIView.animate(withDuration: 0.2) {
//            self.tableView.isEditing = !self.tableView.isEditing
//        }
//        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Готово" : "Править"
    }
    
    private func removePlace() {
        if let indexPath = viewModel.toDeletePlaceIndexPath {
            viewModel.updatedUserInfo.favouritePlaces.remove(at: indexPath.row)
            viewModel.userInfo.value = viewModel.updatedUserInfo
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension FavouritePlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.updatedUserInfo.favouritePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: viewModel.updatedUserInfo.favouritePlaces[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.toDeletePlaceIndexPath = indexPath
            addActionSheet(with: ["Удалить"], and: [removePlace], and: [.destructive])
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.placeProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
