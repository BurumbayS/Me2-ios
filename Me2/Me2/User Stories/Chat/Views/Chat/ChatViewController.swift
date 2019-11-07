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
import NVActivityIndicatorView

class ChatViewController: UIViewController {

    @IBOutlet weak var loader: NVActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageInputView: UIView!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel: ChatViewModel!
    var messageCellID = "ChatMessageCell"
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        viewModel.abortConnection()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addDismissKeyboard()
        
        bindDynamics()
        configureViews()
        configureCollectionView()
        
        setUpConnection()
        showLoader()
        loadMessages()
    }
    
    private func bindDynamics() {
        viewModel.onNewMessage = ({ messages in
            self.collectionView.insertItems(at: [IndexPath(row: messages.count - 1, section: 0)])
            
            //scroll to bottom if the last sended is my message or i'm at the end of chat
            if self.collectionView.contentOffset.y > self.collectionView.contentSize.height - self.collectionView.frame.height - 100 || (messages.last?.isMine())! {
                self.collectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
            }
        })
        
        viewModel.onPrevMessagesLoad = ({ previousMessages, allMessages in
            var indexPathes = [IndexPath]()
            for i in 0..<previousMessages.count {
                indexPathes.append(IndexPath(row: i, section: 0))
            }
            
            let oldContentHeight = self.collectionView.contentSize.height
            let oldContentOffset = self.collectionView.contentOffset.y
            self.collectionView.reloadDataWithCompletion {
                let newContentHeight = self.collectionView.contentSize.height
                
                //if its the first portion of messages
                if oldContentHeight == 0 {
                    self.collectionView.contentOffset.y = newContentHeight - self.collectionView.frame.height + self.collectionView.contentInset.bottom
                } else {
                    self.collectionView.contentOffset.y = oldContentOffset + (newContentHeight - oldContentHeight)
                }
                self.collectionView.layoutIfNeeded()
            }
        })
    }
    
    private func loadMessages() {
        viewModel.loadMessages { [weak self] (status, message) in
            switch status {
            case .ok:
                
                self?.hideLoader()
                
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
        sendButton.isHidden = true
        
        messageTextField.autocapitalizationType = .sentences
        messageTextField.font = UIFont(name: "Roboto-Regular", size: 15)
        messageTextField.addTarget(self, action: #selector(messageEdited), for: .editingChanged)
        messageTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        messageTextField.layer.borderWidth = 1
        messageTextField.layer.borderColor = Color.gray.cgColor
        
        messageInputView.layer.borderWidth = 1
        messageInputView.layer.borderColor = Color.gray.cgColor
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: messageInputView.frame.height + 20, right: 0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        for i in 0..<20 {
            let cellID = "\(messageCellID)\(i)"
            collectionView.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        }
        collectionView.register(LoadingMessagesCollectionViewCell.self)
        collectionView.register(LiveChatMessageCollectionViewCell.self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            inputViewBottomConstraint.constant = keyboardHeight
            collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: keyboardHeight + messageInputView.frame.height + 20, right: 0)
            
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if self.viewModel.messages.count > 0 {
                    self.collectionView.scrollToItem(at: IndexPath(row: self.viewModel.messages.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        inputViewBottomConstraint.constant = 0
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: messageInputView.frame.height + 20, right: 0)
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func showLoader() {
        loader.startAnimating()
    }
    
    private func hideLoader() {
        loader.stopAnimating()
    }
    
    @objc private func messageEdited() {
        if messageTextField.text != "" {
            sendButton.isHidden = false
        } else {
            sendButton.isHidden = true
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        guard let text = messageTextField.text, text != "" else { return }
        
        viewModel.sendMessage(with: text)
        
        messageTextField.text = ""
    }
    
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = viewModel.heightForCell(at: indexPath)
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = viewModel.messages[indexPath.row]
        
        if viewModel.room.type == .LIVE && !message.isMine() {
            
            let cell: LiveChatMessageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: message, and: viewModel.room.getSender(of: message))
            return cell
            
        }
        
        let cellID = "\(messageCellID)\(indexPath.row % 20)"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCollectionViewCell
        
        cell.configure(message: viewModel.messages[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            loadMessages()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // on reach the top (including top content inset) show loading animation
        if scrollView.contentOffset.y < -30 {
            showLoader()
        }
    }
}
