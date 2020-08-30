//
//  WaveCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/19/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class WaveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var wavBackButton: UIButton!
    
    var waveBackHandler: VoidBlock?
    var blockUserHandler: VoidBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }

    func configure(message: Message, secondParticipantName: String, onWaveBack: VoidBlock?, onBlockUser: VoidBlock?) {
        self.waveBackHandler = onWaveBack
        self.blockUserHandler = onBlockUser
        
        if message.isMine() {
            let text = "Вы помахали \(secondParticipantName)"
            
            textLabel.attributedText = getHighlighted(username: secondParticipantName, inString: text)
        } else {
            let text = "\(secondParticipantName) Вам помахал(а)"
            
            textLabel.attributedText = getHighlighted(username: secondParticipantName, inString: text)
        }
    }
    
    private func configureViews() {
        blockButton.layer.borderWidth = 1
        blockButton.layer.borderColor = Color.red.cgColor
        blockButton.layer.cornerRadius = 18
        
        wavBackButton.layer.borderWidth = 1
        wavBackButton.layer.borderColor = Color.blue.cgColor
        wavBackButton.layer.cornerRadius = 18
    }
    
    private func getHighlighted(username: String, inString text: String) -> NSMutableAttributedString {
        let usernameRange = (text as NSString).range(of: username)
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 17) as Any])
        
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont(name: "Roboto-Medium", size: 17) as Any, NSAttributedString.Key.foregroundColor : UIColor.darkGray], range: usernameRange)
        
        return attributedString
    }
    
    @IBAction func waveBackPressed(_ sender: Any) {
        waveBackHandler?()
    }
}
