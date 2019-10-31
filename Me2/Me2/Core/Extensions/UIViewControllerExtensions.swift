//
//  UIViewControllerExtensions.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

let window = UIApplication.shared.keyWindow!

extension UIViewController {
    func addActionSheet(with titles: [String], and actions: [VoidBlock?], and styles: [UIAlertAction.Style]) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for i in 0..<titles.count {
            let action = UIAlertAction(title: titles[i], style: styles[i]) { (action) in
                actions[i]?()
            }
            
            actionSheetController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func setUpBackBarButton(for navItem: UINavigationItem) {
        navItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    @objc func dismissSelf() {
        navigationController?.popViewController(animated: true)
    }
    
    func showDefaultAlert(with message: String, doneAction: VoidBlock?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.setMessage(font: UIFont(name: "Roboto-Regular", size: 15), color: .black)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (alert) in
            doneAction?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func safeAreaSize() -> CGSize {
        var height = CGFloat()
        
        if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
            height = tabBarHeight + (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        } else {
            height = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        }
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - height)
    }
    
    func addDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
