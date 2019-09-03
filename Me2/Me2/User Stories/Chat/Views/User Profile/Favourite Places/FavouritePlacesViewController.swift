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
    
    var cells = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTabeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Любимые места"
        
        let rightItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editTableView))
        rightItem.tintColor = Color.red
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func configureTabeView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double(Float.leastNormalMagnitude)))
        
        tableView.registerNib(PlaceTableViewCell.self)
    }
    
    @objc private func editTableView() {
        UIView.animate(withDuration: 0.2) {
            self.tableView.isEditing = !self.tableView.isEditing
        }
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Готово" : "Править"
    }
}

extension FavouritePlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            cells -= 1
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.placeProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
