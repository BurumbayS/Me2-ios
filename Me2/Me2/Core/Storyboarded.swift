//
//  Storyboarded.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

import UIKit

public protocol Storyboarded where Self: UIViewController { }

extension Storyboarded {
    
    public static func instantiate(storyboardName: String = "Main") -> Self {
        
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)
        
        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]
        
        // load our storyboard
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
