//
//  Dynamic.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

public class Dynamic<T> {
    public typealias Listener = (T) -> ()
    
    public var listeners: [Listener] = []
    
    public func bind(_ listener: @escaping Listener) {
        listeners.append(listener)
    }
    
    public func bindAndFire(_ listener: @escaping Listener) {
        listeners.append(listener)
        fire(for: value)
    }
    
    private func fire(for value: T) {
        listeners.forEach { $0(value) }
    }
    
    public var value: T {
        didSet {
            fire(for: value)
        }
    }
    
    public init(_ v: T) {
        value = v
    }
}
