//
//  EditProfileViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = EditProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
    }
    
    private func configureNavBar() {
        navbar.isTranslucent = false
        navbar.shouldRemoveShadow(true)
        
        navItem.title = "Редактировать профиль"
        
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelEditing))
        cancelButton.tintColor = Color.red
        navItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(finishEditing))
        doneButton.tintColor = Color.blue
        navItem.rightBarButtonItem = doneButton
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color.lightGray
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 20
        
        tableView.registerNib(EditProfileHeaderTableViewCell.self)
        tableView.register(EditProfileTableViewCell.self)
        tableView.register(EditProfileBioTableViewCell.self)
        tableView.register(EditProfileTagsTableViewCell.self)
    }
    
    @objc private func cancelEditing() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func finishEditing() {
        viewModel.updateProfile()
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.cells[indexPath.row]
        
        switch cellType {
        case .mainInfo:
            
            let cell: EditProfileHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.dataFor(cellType: cellType), userDataToSave: viewModel.dataToSave[indexPath.row], controllerPresenter: self, actionSheetPresenter: self)
            return cell
            
        case .firstname, .lastname, .dateOfBirth:
            
            let cell: EditProfileTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.dataFor(cellType: cellType), userDataToSave: viewModel.dataToSave[indexPath.row], cellType: cellType)
            return cell
            
        case .bio:
            
            let cell: EditProfileBioTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.dataFor(cellType: cellType), userDataToSave: viewModel.dataToSave[indexPath.row], cellType: cellType)
            return cell
            
        case .interests:
            
            let cell: EditProfileTagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(activateTagAddition: viewModel.activateAddTagTextField) { [weak self] in
                self?.tableView.beginUpdates()
                    cell.updateHeight()
                self?.tableView.endUpdates()
            }
            return cell

        }
    }
}

extension EditProfileViewController: ControllerPresenterDelegate, ActionSheetPresenterDelegate {
    func present(controller: UIViewController, presntationType: PresentationType) {
        switch presntationType {
        case .push:
            navigationController?.pushViewController(controller, animated: true)
        case .present:
            present(controller, animated: true, completion: nil)
        }
    }
    
    func present(with titles: [String], actions: [VoidBlock?], styles: [UIAlertAction.Style]) {
        self.addActionSheet(with: titles, and: actions, and: styles)
    }
}
