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
    var labelOverlapped = [Int: Bool]()
    
    func configure(with places: [PlacePin], on map: GMSMapView) {
        self.labels.forEach { $0.removeFromSuperview() }
        self.isHidden = false
        
        self.places = places
        self.map = map
        self.labels = []
        
        for (i, place) in places.enumerated() {
            let width = place.name.getWidth(with: UIFont(name: "Roboto-Medium", size: 13)!)
            let height = place.name.getHeight(withConstrainedWidth: 120, font: UIFont(name: "Roboto-Medium", size: 13)!)
            
            let point = map.projection.point(for: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
            let x = point.x + 18 + 5
            let y = point.y - 18 - (height / 2)
            
            let label = UILabel(frame: CGRect(x: x, y: y, width: min(120 , width), height: height))
            label.text = place.name
            label.numberOfLines = 0
            label.font = UIFont(name: "Roboto-Medium", size: 13)
            
            label.tag = i
            
            self.addSubview(label)
            labels.append(label)
            labelOverlapped[i] = false
        }
    }
    
    func updateCoordinates() {
        for (i, label) in labels.enumerated() {
            let height = places[i].name.getHeight(withConstrainedWidth: 120, font: UIFont(name: "Roboto-Medium", size: 13)!)
            
            let point = map.projection.point(for: CLLocationCoordinate2D(latitude: places[i].latitude, longitude: places[i].longitude))
            let x = point.x + 18 + 5
            let y = point.y - 18 - (height / 2)
            
            UIView.animate(withDuration: 0.000000001) {
                label.frame.origin.x = x
                label.frame.origin.y = y
//                label.transform = CGAffineTransform.tra/
            }
        }
        
        hideOverlappingLabels()
    }
    
    private func hideOverlappingLabels() {
        for (i, _) in labels.enumerated() { labelOverlapped[i] = false }
        
        let sortedByX = labels.sorted { $0.frame.origin.x > $1.frame.origin.x }
        updateLabels(labels: sortedByX)
        
        let sortedByY = labels.sorted { $0.frame.origin.y > $1.frame.origin.y }
        updateLabels(labels: sortedByY)
        
        showNotOverlappedLabels()
    }
    
    private func showNotOverlappedLabels() {
        for label in labels {
            if !labelOverlapped[label.tag]! { label.isHidden = false } //else { label.isHidden = true }
        }
    }
    
    private func updateLabels(labels: [UILabel]) {
        var l = 0
        var r = 0
        while (true) {
            r += 1
            
            if r == labels.count { break }
            
            let label1 = labels[l]
            let label2 = labels[r]
            
            let x1 = label1.frame.origin.x
            let x2 = label2.frame.origin.x
            let y1 = label1.frame.origin.y
            let y2 = label2.frame.origin.y
            let width1 = label1.frame.width
            let width2 = label2.frame.width
            let height1 = label1.frame.height
            let height2 = label2.frame.height
            
            if x2 <= x1 && x2 + width2 >= x1 && y2 - height2 <= y1 && y2 >= y1 && !labelOverlapped[label1.tag]! {
                label2.isHidden = true
                labelOverlapped[label2.tag] = true
                continue
            }
            if x2 <= x1 && x2 + width2 >= x1 && y1 - height1 <= y2 && y1 >= y2 && !labelOverlapped[label1.tag]! {
                label2.isHidden = true
                labelOverlapped[label2.tag] = true
                continue
            }
            if y1 >= y2 && y1 - height1 <= y2 && x1 <= x2 && x1 + width1 >= x2 && !labelOverlapped[label1.tag]! {
                label2.isHidden = true
                labelOverlapped[label2.tag] = true
                continue
            }
            if y1 >= y2 && y1 - height1 <= y2 && x2 <= x1 && x2 + width2 >= x1 && !labelOverlapped[label1.tag]! {
                label2.isHidden = true
                labelOverlapped[label2.tag] = true
                continue
            }
 
            l = r
        }
    }
}
