//
//  PlaceProfileViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceProfileViewController: BaseViewController {

    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var topBarView: UIView!
    
    var viewModel: PlaceProfileViewModel!
    
    var lastContentOffset: CGFloat = 0
    var collectionViewCellheight: CGFloat = 0
    
    let followButton = FollowButton.instanceFromNib()
    var followBtnSize = ConstraintGroup()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    var didLayoutSubviews: Bool = false {
        didSet {
            if self.didLayoutSubviews && !oldValue {
                self.viewModel.isFollowed.value = self.viewModel.place.isFavourite
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCellHeight(_:)), name: .updateCellheight, object: nil)
        
        fetchData()
        setupTopBar()
        configureNavBar()
        configureCollectionView()
        configureCollectionCellDefaultHeight()
        configureActionButton()
        bindViewModel()
    }
    
    private func fetchData() {
        viewModel.fetchData { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.collectionView.reloadData()
                self?.collectionView.alpha = 1.0
            case .error:
                break
            case .fail:
                break
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.pageToShow.bind { [unowned self] (page) in
            self.configureActionButton()
        }
        
        viewModel.isFollowed.bind { [weak self] (isFollowed) in
            switch isFollowed {
            case true:
                self?.updateFollowBtnSize(with: 38, and: 38)
            case false:
                self?.updateFollowBtnSize(with: 38, and: 142)
            }
        }
    }
    
    private func configureActionButton() {
        actionButton.drawShadow(color: UIColor.gray.cgColor, forOpacity: 1, forOffset: CGSize(width: 0, height: 0), radius: 3)
        
        switch viewModel.pageToShow.value {
        case .info:
            
            self.actionButton.alpha = 1.0
            self.actionButton.backgroundColor = Color.red
            self.actionButton.setTitle("Забронировать столик", for: .normal)
            self.actionButton.isHidden = viewModel.placeStatus == .not_registered
            
        case .reviews:
            
            self.actionButton.alpha = 1.0
            self.actionButton.backgroundColor = Color.blue
            self.actionButton.setTitle("Оставить отзыв", for: .normal)
            self.actionButton.isHidden = false
            
        default:
            
            self.actionButton.setTitle("", for: .normal)
            self.actionButton.isHidden = true
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.isHidden = true
        
        navBar.isHidden = true
        navBar.shouldRemoveShadow(true)
        
        navItem.title = viewModel.place.name
        
        setUpBackBarButton(for: navItem)
        navItem.leftBarButtonItem?.tintColor = .black
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "share_icon"), style: .plain, target: self, action: #selector(sharePlace))
        rightItem.tintColor = .black
        navItem.rightBarButtonItem = rightItem
    }
    
    private func setupTopBar() {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "custom_back_button"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchDown)
        
        topBarView.addSubview(backButton)
        constrain(backButton, self.topBarView) { btn, view in
            btn.left == view.left + 17
            btn.centerY == view.centerY
            btn.width == 38
            btn.height == 38
        }
        
        //Share button
        let shareView = UIView()
        shareView.layer.cornerRadius = 19
        shareView.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 0.9)
        
        let shareButton = UIButton()
        shareButton.setImage(UIImage(named: "share_icon"), for: .normal)
        shareButton.addTarget(self, action: #selector(sharePlace), for: .touchDown)
        shareView.addSubview(shareButton)
        constrain(shareButton, shareView) { btn, view in
            btn.centerX == view.centerX
            btn.centerY == view.centerY
            btn.width == 16
            btn.height == 22
        }
        
        self.topBarView.addSubview(shareView)
        constrain(shareView, self.topBarView) { share, view in
            share.right == view.right - 17
            share.centerY == view.centerY
            share.height == 38
            share.width == 38
        }
        
        //Follow button
        followButton.configure(with: viewModel.isFollowed)
        followButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followPlace)))
        self.topBarView.addSubview(followButton)
        constrain(followButton, shareView, self.topBarView) { btn, share, view in
            btn.right == share.left - 16
            btn.centerY == view.centerY
        }
        constrain(followButton, replace: followBtnSize) { btn in
            btn.height == 38
            btn.width == 142
        }
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sharePlace() {
        self.addActionSheet(titles: ["Личным сообщением","Другие соц.сети"], actions: [sharePlaceInApp, sharePlaceViaSocial], styles: [.default, .default])
    }
    
    @objc func followPlace() {
        viewModel.followPlace()
    }
    
    private func sharePlaceViaSocial() {
        let str = viewModel.place.generateShareInfo()
        
        let activityViewController = UIActivityViewController(activityItems: [str], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func goToLiveChat() {
        PushNotificationsRouter.shared.shouldPush(to: "/chat/room/\(viewModel.place.roomInfo.uuid)")
    }
    
    private func sharePlaceInApp() {
        let vc = Storyboard.ShareInAppViewController() as! ShareInAppViewController
        let data = ["place": viewModel.placeJSON.dictionaryObject]
        vc.viewModel = ShareInAppViewModel(data: data as [String : Any])
        self.present(vc, animated: true, completion: nil)
    }
    
    private func updateFollowBtnSize(with height: CGFloat, and width: CGFloat) {
        constrain(followButton, replace: followBtnSize) { btn in
            btn.height == height
            btn.width == width
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.clipsToBounds = false
        collectionView.alpha = 0
        
        let layout = PlaceProfileCollectionLayout()
        layout.configure(with: navBar.frame.size.height + UIApplication.shared.statusBarFrame.height)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(PlaceDetailsCollectionViewCell.self)
        collectionView.register(PlaceProfileHeaderCollectionViewCell.self)
        collectionView.registerHeader(PlaceTabView.self)
        collectionView.registerHeader(UICollectionReusableView.self)
    }
    
    @objc private func updateCellHeight(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let height = dict["tableViewHeight"] as? CGFloat {
                self.updateCollectionViewLayout(with: height)
            }
        }
    }
    
    private func updateCollectionViewLayout(with cellHeight: CGFloat) {
        collectionViewCellheight = max(Constants.shared.minContentSize.height, cellHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func configureCollectionCellDefaultHeight() {
        Constants.shared.minContentSize = CGSize(width: safeAreaSize().width, height: safeAreaSize().height - 39)
        collectionViewCellheight = Constants.shared.minContentSize.height
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        switch viewModel.pageToShow.value {
        case .info:
            
            let dest = Storyboard.bookTableViewController() as! BookTableViewController
            dest.viewModel = BookTableViewModel(placeID: viewModel.place.id)
            present(dest, animated: true, completion: nil)
            
        case .reviews:
            
            let dest = Storyboard.writeReviewViewController() as! WriteReviewViewController
            dest.viewModel = WriteReviewViewModel(placeID: viewModel.place.id)
            navigationController?.pushViewController(dest, animated: true)
            
        default:
            
            break
            
        }
    }
}

extension PlaceProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
        case 0:
            let header: UICollectionReusableView = collectionView.dequeueReusableView(for: indexPath, and: kind)
            return header
        default:
            let header: PlaceTabView = collectionView.dequeueReusableView(for: indexPath, and: kind)
            header.configure(with: viewModel.placeStatus.pagesTitles) { [weak self] (selectedSegment) in
                self?.viewModel.currentPage.value = selectedSegment
            }
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            
            return .init(width: self.view.frame.width, height: 0)
            
        default:
            
            return .init(width: self.view.frame.width, height: 40)
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:

            return .init(width: self.view.frame.width, height: 300)

        default:

            return .init(width: self.view.frame.width, height: collectionViewCellheight)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
        
            let cell: PlaceProfileHeaderCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(place: viewModel.place, viewController: self, onSharePressed: sharePlace, onLiveChatPressed: goToLiveChat)
            
            return cell
            
        default:
            
            let cell: PlaceDetailsCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: viewModel.place, currentPage: viewModel.currentPage, presenterDelegate: self, viewController: self)
            return cell
            
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        lastContentOffset = collectionView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = collectionView.collectionViewLayout as? PlaceProfileCollectionLayout else { return }
        
        if collectionView.contentOffset.y > 100 {
            topBarView.isHidden = true
        } else {
            topBarView.isHidden = false
        }
        
        if collectionView.contentOffset.y > 0 {
            layout.turnPinToVisibleBounds()
        } else {
            layout.offPinToVisibleBounds()
        }
        
        if collectionView.contentOffset.y > 300  {
            navBar.isHidden = false
            navigationController?.navigationBar.barStyle = .default
            collectionView.clipsToBounds = true
        } else {
            navBar.isHidden = true
            navigationController?.navigationBar.barStyle = .black
            collectionView.clipsToBounds = false
        }
        
        if collectionView.contentOffset.y > lastContentOffset && lastContentOffset >= 0 {
            UIView.animate(withDuration: 0.3) {
                self.actionButton.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.actionButton.alpha = 1.0
            }
        }
    }
}

extension PlaceProfileViewController: ControllerPresenterDelegate {
    func present(controller: UIViewController, presntationType: PresentationType, completion: VoidBlock?) {
        switch presntationType {
        case .present:
            present(controller, animated: true, completion: nil)
        case .push:
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
