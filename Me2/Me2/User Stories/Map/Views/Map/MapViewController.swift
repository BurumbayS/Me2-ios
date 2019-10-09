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
    let searchContainerView = UIView()
    let searchBar: SearchBar = {
        return SearchBar.instanceFromNib()
    }()
    let imhereButton = UIButton()
    let imhereIcon = UIImageView()
    let filterButton = UIButton()
    let imhereIconConstraints = ConstraintGroup()
    let helperView = UIView()
    let myLocationButton = UIButton()
    var labelsView: LabelsView!
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    var myLocationMarker = GMSMarker()
    var imHereMarker = GMSMarker()
    var pinsInRadius = [GMSMarker]()
    var pulsingRadius = GMSMarker()
    var radius = GMSCircle()
    
    let searchVC = Storyboard.mapSearchViewController() as! MapSearchViewController
    
    let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        fetchData()
        setUpViews()
        configureLocationManager()
        bindViewModel()
        configureCollectionView()
    }

    private func fetchData() {
        viewModel.getPlacePins { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.setPins()
            case .error:
                break;
            case .fail:
                break;
            }
        }
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
        
        viewModel.currentPlaceCardIndex.bind { [weak self] (index) in
            self?.tappedPinInRadius(marker: (self?.pinsInRadius[index])!)
        }
    }
    
    //MARK: -Configures
    private func configureLocationManager() {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(PlaceCardCollectionViewCell.self)
    }
    
    //MARK: -Selectors
    @objc func showFilter() {
        let vc = Storyboard.mapSearchFilterViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func imereButtonPressed() {
        viewModel.isMyLocationVisible.value = !viewModel.isMyLocationVisible.value
    }
    
    @objc func locateMe() {
        myLocationMarker.position = CLLocationCoordinate2D(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude)
        myLocationMarker.icon = UIImage(named: "my_location_icon")
        myLocationMarker.appearAnimation = .pop
        myLocationMarker.map = mapView
        
        mapView.animate(to: GMSCameraPosition(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude, zoom: 16.5))
    }
    
    //MARK: -My location actions
    private func hideMyLocation() {
        helperView.isHidden = false
        collectionView.isHidden = true
        
        mapView.animate(toZoom: 15.0)
        mapView.clear()
        pinsInRadius = []
        setPins()
    }
    
    private func showMyLocation() {
        helperView.isHidden = true
        if labelsView != nil { labelsView.isHidden = true }
        
        mapView.clear()
        
        setImHerePin()
        animatePulsingRadius()
        
        viewModel.getPlacesInRadius { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
                self?.showPinsInRadius()
            case .error:
                print(message)
            case .fail:
                print("Fail")
            }
        }
    }
    
    private func showPinsInRadius() {
        pulsingRadius.map = nil
        
        for (i, place) in viewModel.places.enumerated() {
            let pin = GMSMarker(position: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitute))
            pin.icon = UIImage(named: "pin_in_radius")
            pin.accessibilityHint = "\(i)"
            pin.map = mapView
            
            pinsInRadius.append(pin)
        }
        
        if pinsInRadius.count > 0 { tappedPinInRadius(marker: pinsInRadius[0]) }
    }
    
    private func setImHerePin() {
        imHereMarker = GMSMarker()
        imHereMarker.position = CLLocationCoordinate2D(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude)
        imHereMarker.icon = UIImage(named: "map_marker_icon")
        imHereMarker.appearAnimation = .pop
        imHereMarker.map = mapView
        
        radius.position = CLLocationCoordinate2D(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude)
        radius.radius = viewModel.radius
        radius.strokeColor = .clear
        radius.fillColor = UIColor(red: 0/255, green: 170/255, blue: 255/255, alpha: 0.2)
        radius.map = mapView
        
        myLocationMarker.map = nil
        
        mapView.animate(to: GMSCameraPosition(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude, zoom: 16.5))
    }
    
    //MARK: -Animations
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
    
    private func animatePulsingRadius() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = UIColor(red: 0/255, green: 170/255, blue: 255/255, alpha: 0.5)
        
        let pulsingAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulsingAnimation.duration = 1
        pulsingAnimation.repeatCount = 10
        pulsingAnimation.autoreverses = false
        pulsingAnimation.fromValue = 0.1
        pulsingAnimation.toValue = 17
        
        view.layer.add(pulsingAnimation, forKey: "scale")
        
        pulsingRadius.position = CLLocationCoordinate2D(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude)
        pulsingRadius.iconView = view
        pulsingRadius.map = mapView
    }
    
    private func tappedPinInRadius(marker: GMSMarker) {
        //Show previous selected marker
        if let pin = pinsInRadius.first(where: { $0.position.latitude == imHereMarker.position.latitude && $0.position.longitude == imHereMarker.position.longitude}) {
            pin.map = mapView
        }
        
        //Move imhere marker to selected position and remove marker on that position
        if let pin = pinsInRadius.first(where: { $0.position.latitude == marker.position.latitude && $0.position.longitude == marker.position.longitude}) {
            pin.map = nil
            imHereMarker.position = marker.position
            
            let index = Int(pin.accessibilityHint!) ?? 0
            collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        viewModel.myLocation = locations.last! as CLLocation
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if labelsView != nil {
            labelsView.updateCoordinates()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if viewModel.isMyLocationVisible.value {
            tappedPinInRadius(marker: marker)
        }
        
        return true
    }
}

extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setCollectionViewLayout() {
        let layout = PlacesCollectionViewLayout()
        layout.currentPage = viewModel.currentPlaceCardIndex
        //calculate item width with indention
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: width, height: 118)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlaceCardCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: viewModel.places[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = Storyboard.placeProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MapViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        imhereButton.isHidden = true
        filterButton.isHidden = false
        helperView.isHidden = true
        labelsView.isHidden = true
        searchContainerView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.searchContainerView.alpha = 1.0
        }
    }
    
    func searchEnded() {
        self.imhereButton.isHidden = false
        self.filterButton.isHidden = true
        labelsView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.searchContainerView.alpha = 0
        }) { (finished) in
            if finished {
                self.searchContainerView.isHidden = true
                self.helperView.isHidden = false
            }
        }
    }
}
