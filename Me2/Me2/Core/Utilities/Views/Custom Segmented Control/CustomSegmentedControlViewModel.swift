//
//  CustomSegmentedControlViewModel.swift
//  iTest
//
//  Created by Sanzhar Burumbay on 2/28/19.
//  Copyright © 2019 Creative Team. All rights reserved.
//

import Foundation

protocol CustomSegmentedControlViewModeling {
    var valueChangedHandler: VoidBlock? { get }
}

class CustomSegmentedControlViewModel : CustomSegmentedControlViewModeling {
    var valueChangedHandler: VoidBlock?
    
    init(valueChangedHandler : @escaping VoidBlock) {
        self.valueChangedHandler = valueChangedHandler
    }
}
