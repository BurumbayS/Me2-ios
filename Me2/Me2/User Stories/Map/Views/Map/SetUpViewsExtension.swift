//
//  SetUpViewsExtension.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/23/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import GoogleMaps

extension MapViewController {
    func setPins() {
        labelsView.configure(with: viewModel.placePins, on: mapView)
        
        for (i, place) in viewModel.placePins.enumerated() {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
            let point = mapView.projection.point(for: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
            marker.zIndex = Int32(17 * Int(point.x * 100))
            let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            iconView.contentMode = .scaleAspectFit
            iconView.layer.cornerRadius = 15
            iconView.clipsToBounds = true
            iconView.kf.setImage(with: URL(string: place.logo ?? ""), placeholder: UIImage(named: "default_pin"), options: [])
            marker.iconView = iconView
            marker.title = "\(i)"
            marker.map = mapView
        }
    }
    
    func setUpViews() {
        setUpMap()
        setUpMyLocationButton()
        setUpLabelsView()
        setUpCollectionView()
        setUpContainerView()
        setUpSearchBar()
        setUpImHereButton()
        setUpFilterButton()
//        setUpHelperView()
    }
    
    private func setUpLabelsView() {
        labelsView = LabelsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        labelsView.backgroundColor = .clear
        labelsView.isUserInteractionEnabled = false
        
        self.view.addSubview(labelsView)
    }
    
    private func setUpCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        setCollectionViewLayout()
        
        self.view.addSubview(collectionView)
        constrain(collectionView, self.view) { collection, view in
            collection.height == 107
            collection.left == view.left
            collection.right == view.right
        }
        constrain(collectionView, self.view, replace: collectionViewConstraints) { collection, view in
            collection.top == view.safeAreaLayoutGuide.bottom + 20
        }
    }
    
    private func setUpMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 43.238949, longitude: 76.889709, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
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
        
        mapView.delegate = self
        self.view = mapView
    }
    
    private func setUpSearchBar() {
        searchBar.configure(with: self, onSearchEnd: searchEnded)
        
        self.view.addSubview(searchBar)
        constrain(searchBar, self.view) { search, view in
            search.left == view.left + 10
            search.top == view.top + 50
            search.height == 36
        }
    }
    
    private func setUpContainerView() {
        let viewModel = MapSearchViewModel(searchValue: searchBar.searchValue)
        searchVC.configure(with: viewModel, delegate: self)
        
        searchContainerView.addSubview(searchVC.view)
        constrain(searchVC.view, searchContainerView) { vc, view in
            vc.top == view.top
            vc.left == view.left
            vc.right == view.right
            vc.bottom == view.bottom
        }
        
        searchContainerView.isHidden = true
        searchContainerView.alpha = 0
        self.view.addSubview(searchContainerView)
        constrain(searchContainerView, self.view) { container, view in
            container.top == view.top
            container.left == view.left
            container.right == view.right
            container.bottom == view.safeAreaLayoutGuide.bottom
        }
    }
    
    private func setUpImHereButton() {
        imhereButton.backgroundColor = .white
        imhereButton.layer.cornerRadius = 18
        imhereButton.addTarget(self, action: #selector(imereButtonPressed), for: .touchUpInside)
        
        imhereIcon.image = UIImage(named: "inactive_map_marker_icon")
        imhereIcon.clipsToBounds = false
        imhereButton.addSubview(imhereIcon)
        constrain(imhereIcon, imhereButton, replace: imhereIconConstraints) { icon, button in
            icon.centerX == button.centerX
            icon.centerY == button.centerY
            icon.height == 20
            icon.width == 12
        }
        
        self.view.addSubview(imhereButton)
        constrain(imhereButton, searchBar, self.view ) { btn, search, view in
            btn.left == search.right + 10
            btn.height == 36
            btn.width == 36
            btn.right == view.right - 10
            btn.centerY == search.centerY
        }
    }
    
    private func setUpFilterButton() {
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.setImage(UIImage(named: "filter_icon"), for: .normal)
        filterButton.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
        filterButton.isHidden = true
        
        self.view.addSubview(filterButton)
        constrain(filterButton, searchBar, self.view ) { btn, search, view in
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
        helperView.clipsToBounds = false
        
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
        
        let triangle = UIImageView()
        triangle.image = UIImage(named: "triangle")
        helperView.addSubview(triangle)
        constrain(triangle, helperView) { triangle, view in
            triangle.height == 10
            triangle.width == 17
            triangle.bottom == view.top + 2
            triangle.right == view.right - 10
        }
        
        self.view.addSubview(helperView)
        constrain(helperView, imhereButton) { helper, btn in
            helper.trailing == btn.trailing
            helper.top == btn.bottom + 10
            helper.width == 245
        }
    }
    
    private func setUpMyLocationButton() {
        myLocationButton.setImage(UIImage(named: "my_location_icon"), for: .normal)
        myLocationButton.drawShadow(forOpacity: 0.3, forOffset: CGSize(width: 0, height: 0), radius: 3)
        myLocationButton.addTarget(self, action: #selector(locateMe), for: .touchUpInside)
        
        self.view.addSubview(myLocationButton)
        constrain(myLocationButton, self.view) { btn, view in
            btn.height == 36
            btn.width == 36
            btn.bottom == view.safeAreaLayoutGuide.bottom - 20
            btn.right == view.right - 20
        }
    }
    
    func showHint() {
        if UserDefaults().object(forKey: UserDefaultKeys.firstLaunch.rawValue) != nil { return }
        
        let vc = Storyboard.mapHintViewController()
        vc.modalPresentationStyle = .custom
        present(vc, animated: false, completion: nil)
    }
}
