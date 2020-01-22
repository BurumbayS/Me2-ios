//
//  PlaceOnMapViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/12/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Cartography

class PlaceOnMapViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var mapView: GMSMapView!
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureNavBar()
    }

    private func configureMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: place.latitude, longitude: place.longitute, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        let placePin = GMSMarker(position: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitute))
        placePin.map = mapView
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapConfig", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find MapConfig.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.view.addSubview(mapView)
        constrain(mapView, navBar, self.view) { map, navBar, view in
            map.top == navBar.bottom + 1
            map.left == view.left
            map.right == view.right
            map.bottom == view.bottom
        }
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navItem.title = "Карта"
        setUpBackBarButton(for: navItem)
    }
}
