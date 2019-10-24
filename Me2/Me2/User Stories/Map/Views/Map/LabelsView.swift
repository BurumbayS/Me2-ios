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
        var sortedByX = labels.sorted { $0.frame.origin.x > $1.frame.origin.x }
        
        var l = 0
        var r = 0
        while (true) {
            r += 1
            
            if r == sortedByX.count { break }
            
            let label1 = sortedByX[l]
            let label2 = sortedByX[r]
            
            let x1 = label1.frame.origin.x
            let x2 = label2.frame.origin.x
            let y1 = label1.frame.origin.y
            let y2 = label2.frame.origin.y
            let width2 = label2.frame.width
            let height1 = label1.frame.height
            let height2 = label2.frame.height
            
            if x2 + width2 >= x1 && y2 + height2 >= y1 && y2 <= y1 {
                label2.isHidden = true
                continue
            }
            if x2 + width2 >= x1 && y1 + height1 >= y2 && y1 <= y2 {
                label2.isHidden = true
                continue
            }
            
            l = r
            label1.isHidden = false
            label2.isHidden = false

        }
    }
}
