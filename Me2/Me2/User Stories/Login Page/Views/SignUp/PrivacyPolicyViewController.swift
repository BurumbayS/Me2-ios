//
//  PrivacyPolicyViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import SafariServices

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var privacyPolicyTextView: UITextView!
    
    let privacyPolicyText = "Используя это приложение, Вы принимаете наши Условия и Политику Конфиденциальности."
    let conditions = "Условия"
    let privacyPolicy = "Политику Конфиденциальности"
    let conditionsLink = "https://www.google.com"
    let privacyPolicyLink = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePolicyText()
    }

    private func configurePolicyText() {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedString = NSMutableAttributedString(string: privacyPolicyText,
                                                         attributes: [.paragraphStyle: style,
                                                                      .font: UIFont(name: "Roboto-Bold", size: 24)!,
                                                                      .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        
        if let touRange = findRange(of: conditions, in: privacyPolicyText) {
            attributedString.addAttribute(.link, value: conditionsLink, range: touRange)
        }
        if let ppRange = findRange(of: privacyPolicy, in: privacyPolicyText) {
            attributedString.addAttribute(.link, value: privacyPolicyLink, range: ppRange)
        }
        
        privacyPolicyTextView.delegate = self
        privacyPolicyTextView.attributedText = attributedString
        privacyPolicyTextView.linkTextAttributes = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    private func findRange(of subString: String, in string: String) -> NSRange? {
        guard let index = string.range(of: subString, options: [])?.lowerBound else {
            return nil
        }
        let offset = string.distance(from: string.startIndex, to: index)
        return NSRange(location: offset, length: subString.count)
    }
}

extension PrivacyPolicyViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == privacyPolicyLink && URL.absoluteString == conditionsLink) {
            let svc = SFSafariViewController(url: NSURL(string: URL.absoluteString)! as URL)
            present(svc, animated: true, completion: nil)
        }
        return false
    }
}
