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
    
    var viewModel: WriteReviewViewModel!
    
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
        navBar.isTranslucent = true
        
        setUpBackBarButton(for: navItem)
        
        navItem.title = "Оставить отзыв"
        
        let barButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(sendReview))
        barButton.tintColor = Color.blue
        navItem.rightBarButtonItem = barButton
    }
    
    @objc private func sendReview() {
        self.resignFirstResponder()
        self.startLoader()
        
        viewModel.writeReview(with: reviewContent.text, and: ratingView.rating) { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.stopLoader()
                
                self?.thanksView.isHidden = false
                NotificationCenter.default.post(.init(name: .updateReviews))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self?.navigationController?.popViewController(animated: true)
                })
            case .error, .fail:
                self?.stopLoader(withStatus: .fail, andText: message, completion: nil)
            }
        }
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
