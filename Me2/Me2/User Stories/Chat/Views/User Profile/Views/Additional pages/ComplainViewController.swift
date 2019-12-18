//
//  ComplainViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ComplainViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var textView: UITextView!
    
    let textViewPlaceholder = "Ваша жалоба"
    
    var viewModel: ComplainViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDismissKeyboard()
        configureNavBar()
        configureTextView()
    }
    
    private func configureTextView() {
        textView.textColor = Color.gray
        textView.text = textViewPlaceholder
        textView.delegate = self
    }
    
    private func configureNavBar() {
        navItem.title = "Пожаловаться"
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelComplain))
        navItem.leftBarButtonItem?.tintColor = Color.red
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(completeComplain))
        navItem.rightBarButtonItem?.tintColor = Color.blue
        navItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func cancelComplain() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func completeComplain() {
        viewModel.complainToUser(withText: textView.text) { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.dismiss(animated: true, completion: nil)
            case .error, .fail:
                self?.showInfoAlert(title: "", message: message, onAccept: {
                    self?.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
}

extension ComplainViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = Color.gray
            textView.text = textViewPlaceholder
            navItem.rightBarButtonItem?.isEnabled = false
        }
        
        navItem.rightBarButtonItem?.isEnabled = true
    }
}
