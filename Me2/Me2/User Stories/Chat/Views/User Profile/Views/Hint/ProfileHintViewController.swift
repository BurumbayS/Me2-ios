//
//  ProfileHintViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/19/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ProfileHintViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var maskTopConstraints: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: { [weak self] in
            self?.backView.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    private func setUpViews() {
        backView.alpha = 0
        maskTopConstraints.constant = UIApplication.shared.statusBarFrame.height + 15
    }

    @IBAction func okPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { [weak self] in
            self?.backView.alpha = 0
        }) { [weak self] (_) in
            self?.dismiss(animated: false, completion: nil)
        }
    }
}
