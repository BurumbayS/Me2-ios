//
//  ConfigureAccessCodeViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/14/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ConfigureAccessCodeViewController: UIViewController {
    
    @IBOutlet weak var activationView: UIView!
    @IBOutlet weak var changeView: UIView!
    @IBOutlet weak var changeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var activationSwitcher: UISwitch!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navItem.title = "Код быстрого доступа"
        setUpBackBarButton(for: navItem)
    }
    
    private func configureViews() {
        activationSwitcher.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        changeView.addUnderline(with: .lightGray, and: CGSize(width: changeView.frame.width, height: changeView.frame.height))
        activationView.addUnderline(with: .lightGray, and: CGSize(width: activationView.frame.width, height: activationView.frame.height))
        
        changeView.isUserInteractionEnabled = true
        changeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeAccessCodePressed)))
    }
    
    @objc private func changeAccessCodePressed() {
        let vc = Storyboard.accessCodeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func switchValueChanged() {        
        changeViewHeight.constant = (activationSwitcher.isOn) ? 60 : 0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
