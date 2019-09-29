//
//  WriteReviewViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cosmos

class WriteReviewViewController: UIViewController {

    
    @IBOutlet weak var thanksViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var thanksView: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTextView()
    }

    private func configureTextView() {
        reviewContent.text = "Ваш отзыв"
        reviewContent.textColor = .gray
        
        reviewContent.delegate = self
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navBar.isTranslucent = false
        navBar.shouldRemoveShadow(true)
        
        setUpBackBarButton(for: navItem)
        
        navItem.title = "Оставить отзыв"
        
        let barButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(sendReview))
        barButton.tintColor = Color.blue
        navItem.rightBarButtonItem = barButton
    }
    
    @objc private func sendReview() {
        self.resignFirstResponder()
        thanksView.isHidden = false
//        thanksViewTopConstraint.constant = 0
//
//        UIView.animate(withDuration: 0.2) { [weak self] in
//            self?.view.layoutIfNeeded()
//        }
    }
}

extension WriteReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewContent.textColor == .gray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewContent.textColor == .black && reviewContent.text == "" {
            textView.text = "Ваш отзыв"
            textView.textColor = UIColor.gray
        }
    }
}
