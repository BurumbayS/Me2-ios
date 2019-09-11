//
//  AttributedTextField.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

@IBDesignable
class AttributedTextField: UITextField {
    
    var rightViewAction: VoidBlock?
    
    let leftPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    override func awakeFromNib() {
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.borderColor = Color.gray.cgColor
        self.layer.cornerRadius = 5
    }
    
    // Proides left padding for placeholder and text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = bounds.inset(by: leftPadding)
        return rect
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = bounds.inset(by: leftPadding)
        return rect
    }
    
    // Provides right padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightView = super.rightViewRect(forBounds: bounds)
        rightView.origin.x -= rightPadding
        return rightView
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if rightViewImage == nil { return }
            rightViewImage = (self.isSecureTextEntry) ? UIImage(named: "hide_eye") : UIImage(named: "eye")
        }
    }
    
    @IBInspectable var rightViewImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0
    
    func updateView() {
        if let image = rightViewImage {
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 21, height: 13)
            button.addTarget(self, action: #selector(rightViewPressed), for: .touchUpInside)
            
            rightView = button
            rightViewMode = .always
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
    
    @objc private func rightViewPressed() {
        rightViewAction?()
    }
}
