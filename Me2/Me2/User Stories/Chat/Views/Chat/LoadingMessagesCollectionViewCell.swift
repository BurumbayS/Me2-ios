//
//  LoadingMessagesCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/7/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Cartography

class LoadingMessagesCollectionViewCell: UICollectionViewCell {
    
    let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballBeat, color: .darkGray, padding: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        loader.startAnimating()
    }
    
    private func setupViews() {
        self.contentView.addSubview(loader)
        constrain(loader, self.contentView) { loader, view in
            loader.height == 30
            loader.width == 50
            loader.centerX == view.centerX
            loader.centerY == view.centerY
        }
    }
}
