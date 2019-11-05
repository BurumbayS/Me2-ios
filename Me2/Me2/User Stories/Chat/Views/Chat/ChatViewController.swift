//
//  ChatViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON

class ChatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageInputView: UIView!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel: ChatViewModel!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        tabBarController?.tabBar.isHidden = false
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addDismissKeyboard()
        configureViews()
        configureCollectionView()
        loadMessages()
        bindDynamics()
    }
    
    private func bindDynamics() {
        viewModel.messages.bind { [unowned self] (messages) in
            self.collectionView.insertItems(at: [IndexPath(row: messages.count - 1, section: 0)])
            self.collectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    private func loadMessages() {
        viewModel.loadMessages { [weak self] (status, message) in
            switch status {
            case .ok:
                
                self?.setUpConnection()
                self?.collectionView.reloadData()
                
            case .error:
                break
            case .fail:
                break
            }
        }
    }
    
    private func setUpConnection() {
        viewModel.setUpConnection()
    }
    
    private func configureViews() {
        messageTextField.autocapitalizationType = .sentences
        messageTextField.font = UIFont(name: "Roboto-Regular", size: 15)
        messageTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        messageTextField.layer.borderWidth = 1
        messageTextField.layer.borderColor = Color.gray.cgColor
        
        messageInputView.layer.borderWidth = 1
        messageInputView.layer.borderColor = Color.gray.cgColor
    }

    private func configureCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ChatMessageCollectionViewCell.self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            inputViewBottomConstraint.constant = keyboardSize.height - self.view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if self.viewModel.messages.value.count > 0 {
                    self.collectionView.scrollToItem(at: IndexPath(row: self.viewModel.messages.value.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        inputViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        guard let text = messageTextField.text else { return }
        
        viewModel.sendMessage(with: text)
        
        messageTextField.text = ""
    }
    
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = viewModel.messages.value[indexPath.row].height
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChatMessageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.configure(message: viewModel.messages.value[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
