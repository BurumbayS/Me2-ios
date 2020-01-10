//
//  AboutAppViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class AboutAppViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureData()
    }
    
    private func configureData() {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Версия \(appVersion)"
        }
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        setUpBackBarButton(for: navItem)
        
        navItem.title = "О приложении"
    }
    
    @IBAction func showPrivacyPolicy(_ sender: Any) {
        guard let url = URL(string: "https://api.me2.aiba.kz/static/privacy.pdf") else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func rateApp(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
}
