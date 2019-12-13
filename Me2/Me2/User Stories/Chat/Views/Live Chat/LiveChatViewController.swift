//
//  LiveChatViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import IQKeyboardManagerSwift

class LiveChatViewController: UIViewController {

    @IBOutlet weak var participantsCollectionView: UICollectionView!
    @IBOutlet weak var chatView: UIView!
    
    let chatVC = Storyboard.chatViewController() as! ChatViewController
    
    var viewModel: LiveChatViewModel!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        navigationController?.navigationBar.shouldRemoveShadow(false)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shouldRemoveShadow(true)
        navigationController?.navigationBar.isTranslucent = false
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavBar()
        configureCollectionView()
    }

    private func configureViews() {
        participantsCollectionView.addUnderline(with: Color.gray, and: CGSize(width: participantsCollectionView.frame.width, height: participantsCollectionView.frame.height))
        
        chatVC.viewModel = ChatViewModel(room: viewModel.room)
        chatView.addSubview(chatVC.view)
        constrain(chatVC.view, chatView) { chat, view in
            chat.left == view.left
            chat.right == view.right
            chat.top == view.top
            chat.bottom == view.bottom
        }
    }
    
    private func configureNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dots_icon"), style: .plain, target: self, action: #selector(showActions))
        
        self.navigationItem.twoLineTitleView(titles: ["Live", viewModel.room.name], colors: [Color.blue, .darkGray], fonts: [UIFont(name: "Roboto-Medium", size: 17)!, UIFont(name: "Roboto-Regular", size: 17)!])
    }
    
    private func configureCollectionView() {
        participantsCollectionView.delegate = self
        participantsCollectionView.dataSource = self
        
        participantsCollectionView.registerNib(ParticipantCollectionViewCell.self)
    }
    
    @objc private func showActions() {
        if viewModel.notificationsIsOn {
            self.addActionSheet(titles: ["Профиль заведения","Отключить уведомления"], actions: [goToPlaceProfile, editNotifications], styles: [.default, .destructive])
        } else {
            self.addActionSheet(titles: ["Профиль заведения","Включить уведомления"], actions: [goToPlaceProfile, editNotifications], styles: [.default, .default])
        }
    }
    
    private func goToPlaceProfile() {
        let vc = Storyboard.placeProfileViewController() as! PlaceProfileViewController
        vc.viewModel = PlaceProfileViewModel(place: viewModel.room.place)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func editNotifications() {
        viewModel.editNotifications()
    }
}

extension LiveChatViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.room.participants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ParticipantCollectionViewCell = participantsCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: viewModel.room.participants[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navigationController = Storyboard.userProfileViewController() as! UINavigationController
        let vc = navigationController.viewControllers[0] as! UserProfileViewController
        vc.viewModel = UserProfileViewModel(userID: viewModel.room.participants[indexPath.row].id, profileType: .guestProfile)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
