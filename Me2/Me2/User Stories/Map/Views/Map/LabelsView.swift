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
    var labels = [Int: UILabel]()
    var labelOverlapped = [Int: Bool]()
    var labelToShow = [Int: Bool]()
    var labelSample = UILabel()
    
    func configure(with places: [PlacePin], on map: GMSMapView) {
        self.labels.values.forEach { $0.removeFromSuperview() }
        self.isHidden = false
        
        self.places = places
        self.map = map
        self.labels = [:]
        
        labelSample.numberOfLines = 0
        labelSample.font = UIFont(name: "Roboto-Medium", size: 13)
        
        filterShowedLabels()
        updateCoordinates()
//        for (i, place) in places.enumerated() {
//            let width = place.name.getWidth(with: UIFont(name: "Roboto-Medium", size: 13)!)
//            let height = place.name.getHeight(withConstrainedWidth: 120, font: UIFont(name: "Roboto-Medium", size: 13)!)
//
//            let point = map.projection.point(for: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
//            let x = point.x + 18 + 5
//            let y = point.y - 18 - (height / 2)
//
//            let label = UILabel(frame: CGRect(x: x, y: y, width: min(120 , width), height: height))
//            label.text = place.name
//            label.numberOfLines = 0
//            label.font = UIFont(name: "Roboto-Medium", size: 13)
//
//            label.tag = i
//
//            self.addSubview(label)
//            labels.append(label)
//            labelOverlapped[i] = false
//        }
    }
    
    func updateCoordinates() {
        filterShowedLabels()
        
        for item in labels {
            guard let place = places.first(where: { item.key == $0.id }) else { continue }
            
            DispatchQueue.main.async {
                let height = place.name.getHeight(withConstrainedWidth: 120, font: UIFont(name: "Roboto-Medium", size: 13)!)
                
                let point = self.map.projection.point(for: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
                let x = point.x + 18 + 5
                let y = point.y - 18 - (height / 2)
            
                UIView.animate(withDuration: 0.000001) {
                    item.value.frame.origin = CGPoint(x: x, y: y)
                }
            }
        }
        
        hideOverlappingLabels()
    }
    
    private func filterShowedLabels() {
        for place in places {
            labelOverlapped[place.id] = false
            
            let point = map.projection.point(for: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
            if point.x > 0 && point.x < UIScreen.main.bounds.width && point.y > 0 && point.y < UIScreen.main.bounds.height && map.camera.zoom >= 15 {
                guard labels[place.id] == nil else { continue }

                let width = place.name.getWidth(with: UIFont(name: "Roboto-Medium", size: 13)!)
                let height = place.name.getHeight(withConstrainedWidth: 120, font: UIFont(name: "Roboto-Medium", size: 13)!)
                
                let x = point.x + 18 + 5
                let y = point.y - 18 - (height / 2)
                let label = UILabel(frame: CGRect(x: x, y: y, width: min(120 , width), height: height))
                label.numberOfLines = 0
                label.font = UIFont(name: "Roboto-Medium", size: 13)
                label.textColor = .black
                label.tag = place.id
                
                label.text = place.name
                labels[place.id] = label
                
                self.addSubview(label)
            } else {
                labels[place.id]?.removeFromSuperview()
                labels.removeValue(forKey: place.id)
            }
        }
    }
    
    private func hideOverlappingLabels() {
        for i in labels.keys { labelOverlapped[i] = false }
        
        let sortedByX = labels.values.sorted { $0.frame.origin.x > $1.frame.origin.x }
        updateLabels(labels: sortedByX)
        
//        let sortedByY = labels.values.sorted { $0.frame.origin.y > $1.frame.origin.y }
//        updateLabels(labels: sortedByY)
        
        showNotOverlappedLabels()
    }
    
    private func showNotOverlappedLabels() {
        for label in labels {
            if label.value.text == "Pinseria by Parmigiano Group" {
                
            }
            if !labelOverlapped[label.key]! {
                if let showLabel = labelToShow[label.key] {
                    label.value.isHidden = !showLabel
                } else {
                    label.value.isHidden = false
                }
            }
        }
    }
    
    private func updateLabels(labels: [UILabel]) {
        guard labels.count > 0 else { return }
        
        for i in 0..<labels.count-1 {
            for j in i+1..<labels.count {
                if labels[i].text == "Pinseria by Parmigiano Group" && labels[j].text == "Starbucks Coffee" {
                    
                }
                
                if doOverlapp(label1: labels[i], label2: labels[j]) {
                    labels[j].isHidden = true
                    labelOverlapped[labels[j].tag] = true
                }
            }
        }
//        var l = 0
//        var r = 0
//        while (true) {
//            r += 1
//
//            if r == labels.count { break }
//
//            let label1 = labels[l]
//            let label2 = labels[r]
//
//            let x1 = label1.frame.origin.x
//            let x2 = label2.frame.origin.x
//            let y1 = label1.frame.origin.y
//            let y2 = label2.frame.origin.y
//            let width1 = label1.frame.width
//            let width2 = label2.frame.width
//            let height1 = label1.frame.height
//            let height2 = label2.frame.height
//
//            if x2 <= x1 && x2 + width2 >= x1 && y2 - height2 <= y1 && y2 >= y1 && !labelOverlapped[label1.tag]! {
//                label2.isHidden = true
//                labelOverlapped[label2.tag] = true
//                continue
//            }
//            if x2 <= x1 && x2 + width2 >= x1 && y1 - height1 <= y2 && y1 >= y2 && !labelOverlapped[label1.tag]! {
//                label2.isHidden = true
//                labelOverlapped[label2.tag] = true
//                continue
//            }
//            if y1 >= y2 && y1 - height1 <= y2 && x1 <= x2 && x1 + width1 >= x2 && !labelOverlapped[label1.tag]! {
//                label2.isHidden = true
//                labelOverlapped[label2.tag] = true
//                continue
//            }
//            if y1 >= y2 && y1 - height1 <= y2 && x2 <= x1 && x2 + width2 >= x1 && !labelOverlapped[label1.tag]! {
//                label2.isHidden = true
//                labelOverlapped[label2.tag] = true
//                continue
//            }
//
//            l = r
//        }
    }
    
    func doOverlapp(label1: UILabel, label2: UILabel) -> Bool {
        let x1 = label1.frame.origin.x
        let x2 = label2.frame.origin.x
        let y1 = label1.frame.origin.y
        let y2 = label2.frame.origin.y
        let width1 = label1.frame.width
        let width2 = label2.frame.width
        let height1 = label1.frame.height
        let height2 = label2.frame.height
       
        if x1 <= x2 && x1 + width1 >= x2 && y1 >= y2 && y1 - height1 <= y2 && !labelOverlapped[label1.tag]! {
            return true
        }
        if x1 <= x2 && x1 + width1 >= x2 && y2 >= y1 && y2 - height2 <= y1 && !labelOverlapped[label1.tag]! {
            return true
        }
        if x2 <= x1 && x2 + width2 >= x1 && y2 >= y1 && y2 - height2 <= y1 && !labelOverlapped[label1.tag]! {
            return true
        }
        if x2 <= x1 && x2 + width2 >= x1 && y1 >= y2 && y1 - height1 <= y2 && !labelOverlapped[label1.tag]! {
            return true
        }
        
       return false
    }
}
