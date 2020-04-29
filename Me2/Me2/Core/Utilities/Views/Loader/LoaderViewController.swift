//
//  LoaderViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 4/3/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum LoadingStatus {
    case success
    case fail
    case dismiss
}

class LoaderViewController: UIViewController {

    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loader: NVActivityIndicatorView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var successIcon: UIImageView!
    @IBOutlet weak var failIcon: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var loadingCompletionHandler: VoidBlock?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        loader.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loader.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }

    private func configureViews() {
        statusView.alpha = 0
        
        loaderView.isHidden = false
        loader.color = .darkGray
        loader.type = .ballSpinFadeLoader
        loader.startAnimating()
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
    }
    
    func succes(withMessage message: String) {
        failIcon.isHidden = true
        successIcon.isHidden = false
        statusLabel.text = message
        
        dismissWithStatus()
    }
    
    func fail(withMessage message: String) {
        failIcon.isHidden = false
        successIcon.isHidden = true
        statusLabel.text = message
        
        dismissWithStatus()
    }
    
    func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: false) { [weak self] in
                self?.loadingCompletionHandler?()
            }
        }
    }
    
    private func dismissWithStatus() {
        loaderView.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            self.statusView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.dismiss(animated: false, completion: {
                self.statusView.alpha = 0
                self.loaderView.isHidden = false
                self.loadingCompletionHandler?()
            })
        }
    }

}
