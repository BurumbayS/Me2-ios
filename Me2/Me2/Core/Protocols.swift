//
//  Protocols.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

enum PresentationType {
    case present
    case push
}

protocol ControllerPresenterDelegate {
    func present(controller: UIViewController, presntationType: PresentationType, completion: VoidBlock?)
}

protocol ActionSheetPresenterDelegate {
    func present(with titles: [String], actions: [VoidBlock?], styles: [UIAlertAction.Style])
}
