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
    var collectionView: UICollectionView!
    let searchBar: SearchBar = {
        return SearchBar.instanceFromNib()
    }()
    let imhereButton = UIButton()
    let imhereIcon = UIImageView()
    let imhereIconConstraints = ConstraintGroup()
    let helperView = UIView()
    let myLocationButton = UIButton()
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var myLocation = CLLocation()
    
    var myLocationMarker = GMSMarker()
    var pinMarker = GMSMarker()
    var radius = GMSCircle()
    
    let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpLocationManager()
        bindViewModel()
        configureCollectionView()
    }

    private func bindViewModel() {
        viewModel.isMyLocationVisible.bind { [weak self] (visible) in
            self?.animateImhereIcon()
            
            if visible {
                self?.showMyLocation()
            } else {
                self?.hideMyLocation()
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(PlaceCardCollectionViewCell.self)
    }
    
    private func setUpViews() {
        setUpMap()
        setUpSearchBar()
        setUpImHereButton()
        setUpHelperView()
        setUpMyLocationButton()
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.isHidden = true
        setCollectionViewLayout()
        
        self.view.addSubview(collectionView)
        constrain(collectionView, self.view) { collection, view in
            collection.height == 107
            collection.left == view.left
            collection.bottom == view.safeAreaLayoutGuide.bottom - 30
            collection.right == view.right
        }
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
        mapView.delegate = self
        self.view = mapView
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
    
    @objc private func imereButtonPressed() {
        viewModel.isMyLocationVisible.value = !viewModel.isMyLocationVisible.value
    }
    
    private func hideMyLocation() {
        helperView.isHidden = false
        collectionView.isHidden = true
        
        mapView.animate(toZoom: 15.0)
        pinMarker.map = nil
        radius.map = nil
    }
    
    private func showMyLocation() {
        helperView.isHidden = true
        collectionView.isHidden = false
        
        pinMarker.position = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
        pinMarker.icon = UIImage(named: "map_marker_icon")
        pinMarker.appearAnimation = .pop
        pinMarker.map = mapView
        
        radius.position = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
        radius.radius = 200
        radius.strokeColor = .clear
        radius.fillColor = UIColor(red: 0, green: 170, blue: 255, alpha: 0.2)
        radius.map = mapView
        
        myLocationMarker.map = nil
        
        mapView.animate(to: GMSCameraPosition(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, zoom: 16.5))
    }
    
    @objc private func locateMe() {
        myLocationMarker.position = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
        myLocationMarker.icon = UIImage(named: "my_location_icon")
        myLocationMarker.appearAnimation = .pop
        myLocationMarker.map = mapView
        
        mapView.animate(to: GMSCameraPosition(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, zoom: 16.5))
    }
    
    private func animateImhereIcon() {
        imhereIcon.image = (viewModel.isMyLocationVisible.value) ? UIImage(named: ImhereIcon.active.rawValue) : UIImage(named: ImhereIcon.inactive.rawValue)
        let height: CGFloat = (viewModel.isMyLocationVisible.value) ? 29 : 24
        let width: CGFloat = (viewModel.isMyLocationVisible.value) ? 20 : 15
        
        constrain(imhereIcon, imhereButton, replace: imhereIconConstraints) { icon, button in
            icon.centerX == button.centerX
            icon.centerY == button.centerY
            icon.height == height
            icon.width == width
        }
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        constrain(imhereIcon, imhereButton, replace: imhereIconConstraints) { icon, button in
            icon.centerX == button.centerX
            icon.centerY == button.centerY
            icon.height == 20
            icon.width == 12
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.imhereIcon.image = (self.viewModel.isMyLocationVisible.value) ? UIImage(named: ImhereIcon.plain.rawValue) : UIImage(named: ImhereIcon.inactive.rawValue)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        myLocation = locations.last! as CLLocation
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Traveler's coffee"
        
        infoView.addSubview(titleLabel)
        constrain(titleLabel, infoView) { label, view in
            label.top == view.top
            label.left == view.left
            label.right == view.right
        }
        
        let logoImageView = UIImageView(image: UIImage(named: "sample_place_logo"))
        infoView.addSubview(logoImageView)
        constrain(logoImageView, titleLabel, infoView) { logo, label, view in
            logo.top == label.bottom + 15
            logo.height == 50
            logo.width == 50
            logo.centerX == label.centerX
        }
        
        return infoView
    }
}

extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setCollectionViewLayout() {
        let layout = PlacesCollectionViewLayout()
        //calculate item width with indention
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: width, height: 107)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlaceCardCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}
