//
//  MapClusteringExtension.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/17/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import UIKit

extension MapViewController: GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    func setUpCLusterManager() {
        labelsView.configure(with: viewModel.placePins, on: mapView)
        
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [10, 20, 50, 100, 200, 500, 1000, 2000, 3000], backgroundColors: [UIColor(stringHex: "0084C5"),UIColor(stringHex: "0096E0"),UIColor(stringHex: "00AAFF"),UIColor(stringHex: "1FB4FF"),UIColor(stringHex: "41BFFF"),UIColor(stringHex: "41BFFF"),UIColor(stringHex: "41BFFF"),UIColor(stringHex: "41BFFF"),UIColor(stringHex: "41BFFF")])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                    clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems()

        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        clusterManager.cluster()
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    func generateClusterItems() {
        for (i, item) in viewModel.placePins.enumerated() {
            let clusterItem = ClusterItem(position: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), name: item.name, icon: item.logo, id: i, placeID: item.id)
            clusterManager.add(clusterItem)
        }
    }
    
    func hideCluster() {
        labelsView.isHidden = true
        clusterManager.clearItems()
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        let cluster = marker.userData as? GMUCluster
        if let items = cluster?.items {
            for item in items {
                if let marker = item as? ClusterItem {
                    labelsView.labels[marker.placeID]?.isHidden = true
                    labelsView.labelToShow[marker.placeID] = false
                }
            }
        }
    }
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        if let model = object as? ClusterItem {
            let marker = GMSMarker(position: model.position)
            let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            iconView.contentMode = .scaleAspectFit
            iconView.layer.cornerRadius = 15
            iconView.clipsToBounds = true
            iconView.kf.setImage(with: URL(string: model.icon ?? ""), placeholder: UIImage(named: "default_pin"), options: [])
            marker.iconView = iconView
            marker.title = "\(model.id!)"
            
            if let overlapped = labelsView.labelOverlapped[model.placeID], !overlapped {
                labelsView.labels[model.placeID]?.isHidden = false
            } else {
                labelsView.labels[model.placeID]?.isHidden = true
            }
            labelsView.labelToShow[model.placeID] = true
            
            return marker
        }
        return nil
    }
}

