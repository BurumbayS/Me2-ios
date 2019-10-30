//
//  ChatViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageInputView: UIView!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    let viewModel = ChatViewModel()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        tabBarController?.tabBar.isHidden = false
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureViews()
        configureCollectionView()
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ChatMessageCollectionViewCell.self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            inputViewBottomConstraint.constant = keyboardSize.height
            
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                self.collectionView.scrollToItem(at: IndexPath(row: self.viewModel.messages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        inputViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        guard let text = messageTextField.text else { return }
        
        let message = Message(text: text, time: "", type: .my)
        viewModel.messages.append(message)
        
        messageTextField.text = ""
        
        collectionView.insertItems(at: [IndexPath(row: viewModel.messages.count - 1, section: 0)])
        collectionView.scrollToItem(at: IndexPath(row: self.viewModel.messages.count - 1, section: 0), at: .bottom, animated: true)
    }
    
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = viewModel.messages[indexPath.row].height
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChatMessageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.configure(message: viewModel.messages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}
