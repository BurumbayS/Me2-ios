//
//  PlaceDescriptionTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceDescriptionTableViewCell: UITableViewCell {

    let descriptionLabel = UITextView()
    let moreTextButton = UIButton()
    
    var showHideMoreTextHandler: VoidBlock?
    
    let descriptionHeight = ConstraintGroup()
    
    var showMoreText: Bool = false {
        didSet {
            switch self.showMoreText {
            case true:
                descriptionLabel.textContainer.maximumNumberOfLines = 20
                descriptionLabel.textContainer.lineBreakMode = .byWordWrapping
                moreTextButton.setTitle("Скрыть", for: .normal)
            default:
                descriptionLabel.textContainer.maximumNumberOfLines = 2
                descriptionLabel.textContainer.lineBreakMode = .byTruncatingTail
                moreTextButton.setTitle("Подробнее", for: .normal)
            }
        }
    }
    let minimumDescHeight: CGFloat = 40
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text : String, onShowHideMoreText: VoidBlock?) {
        descriptionLabel.text = text
        showHideMoreTextHandler = onShowHideMoreText
    }
    
    func updateUI() {
        
        let height: CGFloat
        
        if showMoreText {
            height = descriptionLabel.text?.getHeight(withConstrainedWidth: self.frame.width - 40, font: UIFont(name: "Roboto-Regular", size: 17)!) ?? 0
        } else {
            height = minimumDescHeight
        }
        
        constrain(descriptionLabel, replace: descriptionHeight) { desc in
            desc.height == height
        }
        
        layoutIfNeeded()
    }
    
    private func setUpViews() {
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        descriptionLabel.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        descriptionLabel.isUserInteractionEnabled = false
        descriptionLabel.textContainer.lineBreakMode = .byTruncatingTail
        descriptionLabel.textContainer.maximumNumberOfLines = 2
        
        self.contentView.addSubview(descriptionLabel)
        constrain(descriptionLabel, self.contentView) { desc, view in
            desc.left == view.left + 20
            desc.right == view.right - 20
            desc.top == view.top + 20
        }
        constrain(descriptionLabel, replace: descriptionHeight) { desc in
            desc.height == minimumDescHeight
        }
        
        moreTextButton.setTitle("Подробнее", for: .normal)
        moreTextButton.setTitleColor(Color.red, for: .normal)
        moreTextButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 13)
        moreTextButton.addTarget(self, action: #selector(showHideMoreText), for: .touchUpInside)
        
        self.contentView.addSubview(moreTextButton)
        constrain(moreTextButton, descriptionLabel, self.contentView) { btn, desc, view in
            btn.trailing == desc.trailing
            btn.top == desc.bottom
            btn.height == 20
            btn.width == 100
            btn.bottom == view.bottom - 20
        }
    }
    
    @objc private func showHideMoreText() {
        showMoreText = !showMoreText
        
        showHideMoreTextHandler?()
    }
}
