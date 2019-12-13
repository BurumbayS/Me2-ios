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
import Cartography
import MobileCoreServices
import AVKit

class ChatViewController: ListContainedViewController {

    @IBOutlet weak var loader: NVActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageInputView: UIView!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    
    var viewModel: ChatViewModel!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        viewModel.abortConnection()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shouldRemoveShadow(false)
        navigationController?.navigationBar.isTranslucent = false
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        viewModel.setUpConnection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addDismissKeyboard()
        
        bindDynamics()
        configureViews()
        configureCollectionView()
        configureNavBar()
        
        showLoader()
        loadMessages()
    }
    
    private func configureNavBar() {
        guard let _ = self.navigationController else { return }
        
        let participant = viewModel.room.getSecondParticipant()

        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        containView.isUserInteractionEnabled = true
        containView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showParticipantProfile)))

        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        imageview.kf.setImage(with: URL(string: participant.avatar), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 18
        imageview.layer.masksToBounds = true
        containView.addSubview(imageview)

        let rightBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.rightBarButtonItem = rightBarButton

        self.navigationItem.twoLineTitleView(titles: [participant.username, participant.fullName], colors: [.black, .darkGray], fonts: [UIFont(name: "Roboto-Medium", size: 17)!, UIFont(name: "Roboto-Regular", size: 17)!])

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func bindDynamics() {
        viewModel.onNewMessage = ({ message in
            self.hideEmptyListStatusLabel()
            self.insertNewMessage(message: message)
        })
        
        viewModel.onMessageUpdate = ({ index in
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: self.viewModel.sections.count - 1)])
        })
        
        viewModel.onMessagesLoad = ({
            (self.viewModel.messages.count > 0) ? self.hideEmptyListStatusLabel() : self.showEmptyListStatusLabel(withText: "У вас пока нет сообщений")
            
            let oldContentHeight = self.collectionView.contentSize.height
            let oldContentOffset = self.collectionView.contentOffset.y
            self.collectionView.reloadDataWithCompletion {
                let newContentHeight = self.collectionView.contentSize.height
                
                //if its the first portion of messages
                if oldContentHeight == 0 {
                    self.collectionView.contentOffset.y = max(oldContentOffset, newContentHeight - self.collectionView.frame.height + self.collectionView.contentInset.bottom)
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
    
    private func insertNewMessage(message: Message) {
        var lastSection = self.viewModel.sections.count - 1
        
        if viewModel.sections[lastSection].date == message.getDateString() {
            viewModel.sections[lastSection].messages.append(message)
            self.collectionView.insertItems(at: [IndexPath(row: viewModel.sections[lastSection].messages.count - 1, section: viewModel.sections.count - 1)])
        } else {
            let newSection = MessagesSection(date: message.getDateString(), messages: [message])
            self.viewModel.sections.append(newSection)
            self.collectionView.insertSections([self.viewModel.sections.count - 1])
        }
        
        //scroll to bottom if the last sended is my message or i'm at the end of chat
        lastSection = self.viewModel.sections.count - 1
        if self.collectionView.contentOffset.y > self.collectionView.contentSize.height - self.collectionView.frame.height - 100 || (message.isMine()) {
            self.collectionView.scrollToItem(at: IndexPath(row: viewModel.sections[lastSection].messages.count - 1, section: viewModel.sections.count - 1), at: .bottom, animated: true)
        }
    }
    
    private func setUpConnection() {
        viewModel.setUpConnection()
    }
    
    private func configureViews() {
        imagePicker.delegate = self
        
        messageTextField.autocapitalizationType = .sentences
        messageTextField.font = UIFont(name: "Roboto-Regular", size: 15)
        messageTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        messageTextField.layer.borderWidth = 1
        messageTextField.layer.borderColor = Color.gray.cgColor
        
        messageInputView.layer.borderWidth = 1
        messageInputView.layer.borderColor = Color.gray.cgColor
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageInputView.frame.height + 20, right: 0)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        for i in 0..<20 {
            let cellID = "\(Message.messageCellID)\(i)"
            collectionView.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        }
        for i in 0..<20 {
            let cellID = "\(MediaFile.mediaFileCellID)\(i)"
            collectionView.register(MediaMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        }
        collectionView.register(LoadingMessagesCollectionViewCell.self)
        collectionView.register(LiveChatMessageCollectionViewCell.self)
        collectionView.registerNib(SharedPlaceCollectionViewCell.self)
//        collectionView.register(MediaMessageCollectionViewCell.self)
        collectionView.registerHeader(SectionDateHeaderCollectionReusableView.self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.hideEmptyListStatusLabel()
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height - (window.rootViewController?.view.safeAreaInsets.bottom ?? 0)//self.view.safeAreaInsets.bottom
            inputViewBottomConstraint.constant = keyboardHeight
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + messageInputView.frame.height + 20, right: 0)
            
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if self.viewModel.messages.count > 0 {
                    let lastSection = self.viewModel.sections.count - 1
                    self.collectionView.scrollToItem(at: IndexPath(row: self.viewModel.sections[lastSection].messages.count - 1, section: lastSection), at: .bottom, animated: true)
                }
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        inputViewBottomConstraint.constant = 0
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageInputView.frame.height + 20, right: 0)
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            if self.messageTextField.text == "" && self.viewModel.messages.count == 0 {
                self.showEmptyListStatusLabel(withText: "У вас пока нет сообщений")
            } else {
                self.hideEmptyListStatusLabel()
            }
        }
    }
    
    private func showLoader() {
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: messageInputView.frame.height + 20, right: 0)
        loader.startAnimating()
    }
    
    private func hideLoader() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageInputView.frame.height + 20, right: 0)
        loader.stopAnimating()
    }
    
    @objc private func showParticipantProfile() {
        let navigationController = Storyboard.userProfileViewController() as! UINavigationController
        let vc = navigationController.viewControllers[0] as! UserProfileViewController
        vc.viewModel = UserProfileViewModel(userID: viewModel.room.getSecondParticipant().id, profileType: .guestProfile)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        guard let text = messageTextField.text, text != "" else { return }
        
        viewModel.sendMessage(ofType: .TEXT, text: text)
        
        messageTextField.text = ""
    }
    
    @IBAction func addAttachmentPressed(_ sender: Any) {
        self.addActionSheet(titles: ["Камера","Фото/Видео","Местоположение"], images: ["black_camera_icon","image_icon","location_icon"], actions: [takePhotoVideo, openPhotoLibrary, addLocation], styles: [.default, .default, .default], tintColor: .black, textAlignment: .left)
    }
    
    private func takePhotoVideo() {
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeMovie, kUTTypeImage] as [String]
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func openPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie, kUTTypeImage] as [String]
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func addLocation() {
    
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let type = info[.mediaType] as? String {
                
                if type == kUTTypeImage as String {
                    guard let image = info[.originalImage] as? UIImage  else { return }
                    
                    self?.viewModel.sendMessage(ofType: .IMAGE, thumbnail: image)
                }
                
                if type == kUTTypeMovie as String {
                    guard let url = info[.mediaURL] as? URL else { return }
                    
                    self?.viewModel.sendMessage(ofType: .VIDEO, videoURL: url, thumbnail: VideoHelper.getVideoThumbnail(fromURL: url))
                }
                
            }
        }
    }
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = viewModel.heightForCell(at: indexPath)
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader: SectionDateHeaderCollectionReusableView = collectionView.dequeueReusableView(for: indexPath, and: UICollectionView.elementKindSectionHeader)
            sectionHeader.configure(with: viewModel.sections[indexPath.section].date)
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = viewModel.sections[indexPath.section].messages[indexPath.row]
        
        if let place = message.place, place.id != 0 {
            
            let cell: SharedPlaceCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(place: place, senderType: .my)
            return cell
            
        }
        
        switch message.type {
        case .TEXT:
            
            if viewModel.room.type == .LIVE && !message.isMine() {
                
                let cell: LiveChatMessageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(with: message, and: viewModel.room.getSender(of: message))
                return cell
                
            }
            
            let cellID = "\(Message.messageCellID)\(indexPath.row % 20)"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCollectionViewCell
            
            cell.configure(message: message)
            
            return cell
            
        case .IMAGE, .VIDEO:
            
            let cellID = "\(MediaFile.mediaFileCellID)\(indexPath.row % 20)"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MediaMessageCollectionViewCell
            cell.configure(message: message, presenterDelegate: self)
            return cell

        default:
            return UICollectionViewCell()
        }
        
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

extension ChatViewController: ControllerPresenterDelegate {
    func present(controller: UIViewController, presntationType: PresentationType, completion: VoidBlock?) {
        switch presntationType {
        case .push:
            self.navigationController?.pushViewController(controller, animated: true)
        case .present:
            self.present(controller, animated: true, completion: completion)
        }
    }
}
