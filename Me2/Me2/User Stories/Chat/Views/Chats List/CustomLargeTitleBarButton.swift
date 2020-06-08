//
//  CustomLargeTitleBarButton.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

struct BarButtonConst {
    /// Image height/width for Large NavBar state
    static let ButtonSizeForLargeState: CGFloat = 25
    /// Margin from right anchor of safe area to right anchor of Image
    static let ButtonRightMargin: CGFloat = 15
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ButtonBottomMarginForLargeState: CGFloat = 15
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ButtonBottomMarginForSmallState: CGFloat = 10
    /// Image height/width for Small NavBar state
    static let ButtoneSizeForSmallState: CGFloat = 22
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class CustomLargeTitleBarButton: UIView {
    var button = UIButton()
    var buttonPressHandler: VoidBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(to view: UIView, with image: UIImage, onPress: VoidBlock?) {
        buttonPressHandler = onPress
        
        button.tintColor = .black
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        view.addSubview(self)
        constrain(self, view) { view, superView in
            view.height == BarButtonConst.ButtonSizeForLargeState
            view.width == BarButtonConst.ButtonSizeForLargeState
            view.bottom == superView.bottom - BarButtonConst.ButtonBottomMarginForLargeState
            view.right == superView.right - BarButtonConst.ButtonRightMargin
        }
    }
    
    @objc private func buttonPressed() {
        buttonPressHandler?()
    }
    
    private func setupViews() {
        self.addSubview(button)
        constrain(button, self) { btn, view in
            btn.left == view.left
            btn.top == view.top
            btn.right == view.right
            btn.bottom == view.bottom
        }
    }
    
    func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - BarButtonConst.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (BarButtonConst.NavBarHeightLargeState - BarButtonConst.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = BarButtonConst.ButtoneSizeForSmallState / BarButtonConst.ButtonSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = BarButtonConst.ButtonSizeForLargeState * (1.0 - factor) // 8.0
        var yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = BarButtonConst.ButtonBottomMarginForLargeState - BarButtonConst.ButtonBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (BarButtonConst.ButtonBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        if #available(iOS 13.0, *) {
           if height > 96 && height < 148 {
               yTranslation = yTranslation - (height - 96)
           }
           if height >= 148 {
               yTranslation = yTranslation - (148 - 96)
           }
        }
        
        self.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
}

