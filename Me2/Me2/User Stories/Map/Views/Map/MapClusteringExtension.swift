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
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                    clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems(rendererr: renderer)

        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        clusterManager.cluster()
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    func generateClusterItems(rendererr: GMUClusterRenderer) {
        for item in viewModel.placePins {
            let clusterItem = ClusterItem(position: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), name: item.name, icon: item.logo)
            clusterManager.add(clusterItem)
        }
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        
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
            
            return marker
        }
        return nil
    }

}

