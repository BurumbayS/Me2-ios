//
//  Protocols.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

protocol ControllerPresenterDelegate {
    func present(controller: UIViewController)
}

protocol ActionSheetPresenterDelegate {
    func present(with titles: [String], actions: [VoidBlock?], styles: [UIAlertAction.Style])
}
