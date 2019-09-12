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
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    let viewModel = PlaceProfileViewModel()
    
    var lastContentOffset: CGFloat = 0
    var collectionViewCellheight: CGFloat = Constants.minContentSize.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCellHeight(_:)), name: .updateCellheight, object: nil)
        configureNavBar()
        configureCollectionView()
    }
    
    private func configureNavBar() {
        navBar.makeTransparentBar()
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
        collectionView.registerHeader(PlaceProfileHeaderView.self)
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
}

extension PlaceProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
        case 0:
            let header: UICollectionReusableView = collectionView.dequeueReusableView(for: indexPath, and: kind)
            return header
        default:
            let header: PlaceProfileHeaderView = collectionView.dequeueReusableView(for: indexPath, and: kind)
            header.configure { [weak self] (selectedSegment) in
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
            cell.configureWith(title: "Traveler's coffee", rating: 3.2, category: "Сеть кофеен")
            return cell
            
        default:
            
            let cell: PlaceDetailsCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: viewModel.currentPage)
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
            navBar.backgroundColor = .white
            collectionView.clipsToBounds = true
        } else {
            navBar.makeTransparentBar()
            collectionView.clipsToBounds = false
        }
    }
}
