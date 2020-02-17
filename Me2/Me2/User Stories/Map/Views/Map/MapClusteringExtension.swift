//
//  MapClusteringExtension.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/17/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import UIKit

extension MapViewController: GMUClusterManagerDelegate {
    func setUpCLusterManager() {
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                    clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)
        // Generate and add random items to the cluster manager.
        generateClusterItems()

        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        clusterManager.cluster()
    }
    
    func generateClusterItems() {
        for item in viewModel.placePins {
            let clusterItem = ClusterItem(position: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), name: item.name)
            clusterManager.add(clusterItem)
        }
    }
}

