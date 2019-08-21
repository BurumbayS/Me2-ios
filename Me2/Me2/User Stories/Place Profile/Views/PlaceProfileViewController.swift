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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        collectionView.collectionViewLayout = PlaceProfileCollectionLayout()
        
        collectionView.registerNib(PlaceDetailsCollectionViewCell.self)
        collectionView.register(PlaceHeaderCell.self)
        collectionView.register(PlaceProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaceHeaderView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeaderView")
    }
}

extension PlaceProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reuseID = "EmptyHeaderView"
        
//        switch indexPath.section {
//        case 0:
//            reuseID = "EmptyHeaderView"
//        default:
//            reuseID = "PlaceHeaderView"
//        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseID, for: indexPath)
        
        let segmentedControl = CustomSegmentedControl()
        segmentedControl.backgroundColor = .white
        segmentedControl.configure(for: ["Инфо","События","Меню","Отзывы"], with: CGSize(width: UIScreen.main.bounds.width, height: 40))
        header.addSubview(segmentedControl)
        constrain(segmentedControl, header) { segmentedControl, header in
            segmentedControl.top == header.top
            segmentedControl.left == header.left
            segmentedControl.right == header.right
            segmentedControl.bottom == header.bottom
        }
        
        return header
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
            
            //set cell height minus section header height
            return .init(width: self.view.frame.width, height: self.view.frame.height - 40)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
        
            let cell: PlaceHeaderCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureWith(title: "Traveler's coffee", rating: 3.2, category: "Сеть кофеен")
            return cell
            
        default:
            
            let cell: PlaceDetailsCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            
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
        
        if collectionView.contentOffset.y > 300 {
            navBar.backgroundColor = .white
            collectionView.clipsToBounds = true
        } else {
            navBar.makeTransparentBar()
            collectionView.clipsToBounds = false
        }
    }
}
