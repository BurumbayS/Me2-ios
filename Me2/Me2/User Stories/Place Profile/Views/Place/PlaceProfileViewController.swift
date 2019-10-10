//
//  PlaceProfileViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var viewModel: PlaceProfileViewModel!
    
    var lastContentOffset: CGFloat = 0
    var collectionViewCellheight: CGFloat = Constants.minContentSize.height
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCellHeight(_:)), name: .updateCellheight, object: nil)
        
        configureNavBar()
        configureCollectionView()
        configureActionButton()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.pageToShow.bind { [unowned self] (page) in
            self.configureActionButton()
        }
    }
    
    private func configureActionButton() {
        if viewModel.placeStatus == .not_registered {
            self.actionButton.setTitle("", for: .normal)
            self.actionButton.isHidden = true
            
            return
        }
        
        actionButton.drawShadow(color: UIColor.gray.cgColor, forOpacity: 1, forOffset: CGSize(width: 0, height: 0), radius: 3)
        
        switch viewModel.pageToShow.value {
        case .info:
            
            self.actionButton.backgroundColor = Color.red
            self.actionButton.setTitle("Забронировать столик", for: .normal)
            self.actionButton.isHidden = false
            
        case .reviews:
            
            self.actionButton.backgroundColor = Color.blue
            self.actionButton.setTitle("Оставить отзыв", for: .normal)
            self.actionButton.isHidden = false
            
        default:
            
            self.actionButton.setTitle("", for: .normal)
            self.actionButton.isHidden = true
        }
    }
    
    private func configureNavBar() {
        navBar.isHidden = true
        navBar.shouldRemoveShadow(true)
        
        navItem.title = viewModel.place.name
        
        setUpBackBarButton(for: navItem)
        navItem.leftBarButtonItem?.tintColor = .black
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "share_icon"), style: .plain, target: self, action: #selector(sharePlace))
        rightItem.tintColor = .black
        navItem.rightBarButtonItem = rightItem
    }
    
    @objc private func sharePlace() {
        
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.clipsToBounds = false
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
        collectionViewCellheight = max(Constants.minContentSize.height, cellHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        switch viewModel.pageToShow.value {
        case .info:
            
            let dest = Storyboard.bookTableViewController()
            present(dest, animated: true, completion: nil)
            
        case .reviews:
            
            let dest = Storyboard.writeReviewViewController()
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
            cell.configure(place: viewModel.place, placeStatus: viewModel.placeStatus, viewController: self)
            return cell
            
        default:
            
            let cell: PlaceDetailsCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: viewModel.currentPage, and: viewModel.placeStatus)
            return cell
            
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = collectionView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = collectionView.collectionViewLayout as? PlaceProfileCollectionLayout else { return }
        
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
    }
}
