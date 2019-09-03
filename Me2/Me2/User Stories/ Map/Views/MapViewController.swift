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
import Cartography

class MapViewController: UIViewController {
    
    let searchBar: SearchBar = {
        return SearchBar.instanceFromNib()
    }()
    let imhereButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }

    private func setUpViews() {
        setUpMap()
        setUpSearchBar()
        setUpImHereButton()
    }
    
    private func setUpMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 43.238949, longitude: 76.889709, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
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
}
