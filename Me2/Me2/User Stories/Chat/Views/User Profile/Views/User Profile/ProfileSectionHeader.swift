//
//  ProfileSectionHeader.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

enum ProfileSectionType {
    case seeMore
    case expand
}

class ProfileSectionHeader: UIView {
    
    let expandButton = UIButton()
    var sectionExpanded = false
    
    var actionHandler: VoidBlock?
    var sectionType: ProfileSectionType!
    
    var layoutSubviews = false
    
    func configure(title: String, type: ProfileSectionType, action: VoidBlock?) {
        self.actionHandler = action
        self.sectionType = type
        
        if !self.layoutSubviews {
            self.layoutSubviews = true
            setUpViews(with: title, and: type)
        }
    }
    
    private func setUpViews(with title: String, and type: ProfileSectionType) {
        let header = self
        
        let label = UILabel()
        label.textColor = .lightGray
        label.text = title
        label.font = UIFont(name: "Roboto-Regular", size: 15)
        
        header.addSubview(label)
        constrain(label, header) { label, header in
            label.left == header.left + 20
            label.height == 20
            label.bottom == header.bottom
        }
        
        let line = UIView()
        line.backgroundColor = .lightGray
        header.addSubview(line)
        constrain(line, label, header) { line, label, header in
            line.left == label.right + 10
            line.centerY == label.centerY
            line.height == CGFloat(0.5)
        }
        
        let moreButton = UIButton()
        moreButton.setTitle("См.все", for: .normal)
        moreButton.setTitleColor(Color.red, for: .normal)
        moreButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        moreButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        expandButton.imageView?.contentMode = .scaleAspectFit
        expandButton.setImage(UIImage(named: "red_down_arrow"), for: .normal)
        expandButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        switch type {
        case .seeMore:
            header.addSubview(moreButton)
            constrain(moreButton, line, label, header) { btn, line, label, header in
                btn.left == line.right + 10
                btn.right == header.right - 20
                btn.centerY == label.centerY
                btn.height == 20
                btn.width == 50
            }
        case .expand:
            header.addSubview(expandButton)
            constrain(expandButton, line, label, header) { btn, line, label, header in
                btn.left == line.right
                btn.right == header.right - 20
                btn.centerY == label.centerY
                btn.height == 20
                btn.width == 30
            }
        }
    }
    
    @objc private func buttonPressed() {
        if sectionType == .expand {
            sectionExpanded = !sectionExpanded
            let rotationAngle = (sectionExpanded) ? Double.pi : Double.pi * 2
            
            UIView.animate(withDuration: 0.3, animations: {
                self.expandButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
            })
        }
        
        actionHandler?()
    }
}
