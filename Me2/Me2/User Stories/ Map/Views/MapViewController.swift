//
//  MapViewControllerViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
import MapKit
import Cartography

class MapViewController: UIViewController {
    
    let searchBar: SearchBar = {
        return SearchBar.instanceFromNib()
    }()
    let imhereButton = UIButton()
    let helperView = UIView()
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpLocationManager()
    }

    private func setUpViews() {
        setUpMap()
        setUpSearchBar()
        setUpImHereButton()
        setUpHelperView()
    }
    
    private func setUpLocationManager() {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setUpMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 43.238949, longitude: 76.889709, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        view = mapView
    }
    
    private func setUpSearchBar() {
        searchBar.isUserInteractionEnabled = true
        self.view.addSubview(searchBar)
        constrain(searchBar, self.view) { search, view in
            search.left == view.left + 10
            search.top == view.top + 50
            search.height == 36
        }
    }
    
    private func setUpImHereButton() {
        imhereButton.setImage(UIImage(named: "imhere_icon"), for: .normal)
        self.view.addSubview(imhereButton)
        constrain(imhereButton, searchBar, self.view ) { btn, search, view in
            btn.left == search.right + 10
            btn.height == 36
            btn.width == 36
            btn.right == view.right - 10
            btn.centerY == search.centerY
        }
    }
    
    private func setUpHelperView() {
        helperView.layer.cornerRadius = 10
        helperView.backgroundColor = .white
        helperView.alpha = 0.8
        
        let label = UILabel()
        label.text = "Включите видимость, чтобы начать общение с другими пользователями"
        label.font = UIFont(name: "SFProRounded-Regular", size: 13)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center 
        
        helperView.addSubview(label)
        constrain(label, helperView) { label, view in
            label.left == view.left + 10
            label.right == view.right - 10
            label.top == view.top + 10
            label.bottom == view.bottom - 10
        }
        
        self.view.addSubview(helperView)
        constrain(helperView, imhereButton) { helper, btn in
            helper.trailing == btn.trailing
            helper.top == btn.bottom + 10
            helper.width == 245
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: 15.0)
        mapView.animate(to: camera)
    }
}
