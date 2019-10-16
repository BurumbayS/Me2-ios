//
//  LabelsView.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/20/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import GoogleMaps

class LabelsView: UIView {
    var places = [PlacePin]()
    var map: GMSMapView!
    var labels = [UILabel]()
    
    func configure(with places: [PlacePin], on map: GMSMapView) {
        self.labels.forEach { $0.removeFromSuperview() }
        self.isHidden = false
        
        self.places = places
        self.map = map
        self.labels = []
        
        for place in places {
            let width = place.name.getWidth(with: UIFont(name: "Roboto-Medium", size: 13)!)
            let height = place.name.getHeight(withConstrainedWidth: 120, font: UIFont(name: "Roboto-Medium", size: 13)!)
            
            let point = map.projection.point(for: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
            let x = point.x + 18 + 5
            let y = point.y - 18 - (height / 2)
            
            let label = UILabel(frame: CGRect(x: x, y: y, width: min(120 , width), height: height))
            label.text = place.name
            label.numberOfLines = 0
            label.font = UIFont(name: "Roboto-Medium", size: 13)
            
            self.addSubview(label)
            labels.append(label)
        }
    }
    
    func updateCoordinates() {
        for (i, label) in labels.enumerated() {
            let height = places[i].name.getHeight(withConstrainedWidth: 120, font: UIFont(name: "Roboto-Medium", size: 13)!)
            
            let point = map.projection.point(for: CLLocationCoordinate2D(latitude: places[i].latitude, longitude: places[i].longitude))
            let x = point.x + 18 + 5
            let y = point.y - 18 - (height / 2)
            
            label.frame.origin.x = x
            label.frame.origin.y = y
        }
        
        hideOverlappingLabels()
    }
    
    private func hideOverlappingLabels() {
        let sortedByX = labels.sorted { $0.frame.origin.x > $1.frame.origin.x }
        
        var l = 0
        var r = 0
        while (true) {
            r += 1
            
            if r == sortedByX.count { break }
            
            let label1 = sortedByX[l]
            let label2 = sortedByX[r]
            
            if label2.frame.origin.x + label2.frame.width > label1.frame.origin.x {
                if label1.frame.origin.y < label2.frame.origin.y && label1.frame.origin.y + label1.frame.height > label2.frame.origin.y {
                    label2.isHidden = true
                }
                if label1.frame.origin.y > label2.frame.origin.y && label2.frame.origin.y + label2.frame.height > label1.frame.origin.y {
                    label2.isHidden = true
                }
                
                continue
            }
            
            l = r
            label1.isHidden = false
            label2.isHidden = false

        }
    }
}
