//
//  PlaceProfileHeaderView.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceProfileHeaderView: UICollectionReusableView {
    
    let segmentedControl = CustomSegmentedControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with segmentChangeHadler: @escaping ((Int) -> ())) {
        let viewModel = CustomSegmentedControlViewModel { [weak self] in
            segmentChangeHadler(self?.segmentedControl.currentSegment ?? 0)
        }
        segmentedControl.configure(for: ["Инфо","События","Меню","Отзывы"], with: CGSize(width: UIScreen.main.bounds.width, height: 40), and: viewModel)
    }
    
    private func setUpViews() {
        segmentedControl.backgroundColor = .white
        self.addSubview(segmentedControl)
        constrain(segmentedControl, self) { segmentedControl, header in
            segmentedControl.top == header.top
            segmentedControl.left == header.left
            segmentedControl.right == header.right
            segmentedControl.bottom == header.bottom
        }
    }
}
