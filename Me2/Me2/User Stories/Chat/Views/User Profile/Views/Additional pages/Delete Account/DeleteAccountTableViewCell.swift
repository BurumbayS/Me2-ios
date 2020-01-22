//
//  DeleteAccountTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/20/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class DeleteAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkedIcon: UIImageView!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var reasonTextViewHeight: NSLayoutConstraint!
    
    var reason: Dynamic<String>!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addUnderline(with: Color.gray, and: CGSize(width: self.frame.width, height: self.frame.height))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    private func configureViews() {
        reasonTextView.layer.borderWidth = 1
        reasonTextView.layer.borderColor = Color.gray.cgColor
        reasonTextView.layer.cornerRadius = 5
        
        reasonTextView.delegate = self
    }
    
    func configure(reasonType: DeleteReason, reasonText: Dynamic<String>, selected: Bool) {
        self.reason = reasonText
        
        titleLabel.text = reasonType.title
        titleLabel.textColor = (selected) ? Color.blue : .black
        
        checkedIcon.isHidden = !selected
        
        if reasonType == .OTHER {
            reasonTextViewHeight.constant = 100
        } else {
            reasonTextViewHeight.constant = 0
        }
        
        if selected {
            reasonTextView.layer.borderColor = Color.blue.cgColor
            reasonTextView.becomeFirstResponder()
        } else {
            reasonTextView.layer.borderColor = Color.gray.cgColor
        }
    }
}

extension DeleteAccountTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        reason.value = textView.text
    }
}
