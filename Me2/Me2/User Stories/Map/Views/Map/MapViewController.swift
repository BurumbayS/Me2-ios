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
import OneSignal

class MapViewController: BaseViewController {
    var collectionView: UICollectionView!
    let searchContainerView = UIView()
    let searchBar: SearchBar = {
        return SearchBar.instanceFromNib()
    }()
    let imhereButton = UIButton()
    let imhereIcon = UIImageView()
    let filterButton = UIButton()
    let helperView = UIView()
    let myLocationButton = UIButton()
    var labelsView: LabelsView!
    
    let imhereIconConstraints = ConstraintGroup()
    let collectionViewConstraints = ConstraintGroup()
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var clusterManager: GMUClusterManager!
    
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
        
        setUpViews()
        fetchData()
        configureLocationManager()
        bindViewModel()
        configureCollectionView()
        subscribeForNotifications()
    }

    private func subscribeForNotifications() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            if accepted {
                OneSignal.setSubscription(true)
            } else {
                OneSignal.setSubscription(false)
            }
        })
    }
    
    private func fetchData() {
        startLoader()
        
        viewModel.getPlacePins { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.stopLoader()
                self?.setUpCLusterManager()
                self?.showHint()
            case .error, .fail:
                self?.stopLoader(withStatus: .fail, andText: message, completion: nil)
            }
        }
    }
    
    private func getPlacesInRadius() {
        viewModel.getPlacesInRadius { [weak self] (status, message) in
            switch status {
            case .ok:
                if (self?.viewModel.isMyLocationVisible.value)! && (self?.viewModel.places.count)! > 0 {
                    self?.showCollectionView()
                    self?.showPinsInRadius()
                } else {
                    self?.viewModel.isMyLocationVisible.value = false
                    self?.showDefaultAlert(title: "", message: "Возле Вас не обнаружено заведений. Попробуйте снова, когда измените свое местоположение.", doneTitle: "Попробовать снова", cancelTitle: "Отключить \"Я тут\"", doneAction: {
                        self?.viewModel.isMyLocationVisible.value = true
                    }, onCancel: {
                        self?.viewModel.isMyLocationVisible.value = false
                    })
                }
            case .error:
                print(message)
            case .fail:
                print("Fail")
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.isMyLocationVisible.bind { [weak self] (visible) in
            self?.animateImhereIcon()
            
            if visible {
                self?.showMyLocation()
            } else {
                self?.viewModel.exitAllRooms()
                self?.hideMyLocation()
            }
        }
        
        viewModel.currentPlaceCardIndex.bind { [weak self] (index) in
            self?.tappedPinInRadius(marker: (self?.pinsInRadius[index])!)
            self?.viewModel.enterNewRoom(at: index)
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
        let dest = Storyboard.mapSearchFilterViewController() as! UINavigationController
        let vc = dest.viewControllers[0] as! MapSearchFilterViewController
        vc.viewModel = MapSearchFilterViewModel(filtersData: searchVC.viewModel.filterData)
        present(dest, animated: true, completion: nil)
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
        hideCollectionView()
        
        mapView.animate(toZoom: 15.0)
        mapView.clear()
        
        pinsInRadius = []
        generateClusterItems()
//        setPins()
    }
    
    private func showMyLocation() {
        helperView.isHidden = true
        if labelsView != nil { labelsView.isHidden = true }
        
        hideCluster()
        mapView.clear()
        
        setImHerePin()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.getPlacesInRadius()
        })
    }
    
    private func showPinsInRadius() {
        pulsingRadius.map = nil
        
        radius.position = CLLocationCoordinate2D(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude)
        radius.radius = viewModel.radius
        radius.strokeColor = .clear
        radius.fillColor = UIColor(red: 0/255, green: 170/255, blue: 255/255, alpha: 0.2)
        radius.map = mapView
        
        for (i, place) in viewModel.places.enumerated() {
            let pin = GMSMarker(position: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitute))
            pin.icon = UIImage(named: "pin_in_radius")
            pin.accessibilityHint = "\(i)"
            pin.map = mapView
            
            pinsInRadius.append(pin)
        }
        
        if pinsInRadius.count > 0 {
            tappedPinInRadius(marker: pinsInRadius[0])
            viewModel.currentPlaceCardIndex.value = 0
        }
    }
    
    private func setImHerePin() {
        imHereMarker = GMSMarker()
        imHereMarker.zIndex = 100000
        imHereMarker.position = CLLocationCoordinate2D(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude)
        imHereMarker.icon = UIImage(named: "map_marker_icon")
        imHereMarker.appearAnimation = .pop
        imHereMarker.map = mapView
        
        myLocationMarker.map = nil
        
        mapView.animate(to: GMSCameraPosition(latitude: viewModel.myLocation.coordinate.latitude, longitude: viewModel.myLocation.coordinate.longitude, zoom: 16.5))
        
        animatePulsingRadius(atPosition: imHereMarker.position)
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
    
    private func animatePulsingRadius(atPosition pos: CLLocationCoordinate2D) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let image = UIImageView(image: UIImage(named: "pulsingRadius"))
        image.frame = CGRect(x: 5, y: 5, width: 295, height: 295)
        view.addSubview(image)

        let pulsingAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        pulsingAnimation.duration = 1
        pulsingAnimation.repeatCount = 50
        pulsingAnimation.autoreverses = false
        pulsingAnimation.fromValue = 0
        pulsingAnimation.toValue = 1

        image.layer.add(pulsingAnimation, forKey: "scale")
        view.layer.add(pulsingAnimation, forKey: "scale")
        
        
        pulsingRadius.position = pos
        pulsingRadius.groundAnchor = CGPoint(x: 0.5, y: 0.5)// CGPointMake(0.5, 0.5);
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
    
    private func tappedSinglePlacePin(atIndex index: Int) {
        viewModel.getPlaceCardInfo(with: viewModel.placePins[index].id) { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.showCollectionView()
            case .error:
                print(message)
            case .fail:
                print("Fail")
            }
        }
    }
    
    private func showCollectionView() {
        collectionView.reloadData()
        
        constrain(collectionView, self.view, replace: collectionViewConstraints) { collection, view in
            collection.bottom == view.safeAreaLayoutGuide.bottom - 30
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideCollectionView() {
        constrain(collectionView, self.view, replace: collectionViewConstraints) { collection, view in
            collection.top == view.safeAreaLayoutGuide.bottom + 20
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func goToLiveChat(in place: Place) {
        if viewModel.isMyLocationVisible.value {
            PushNotificationsRouter.shared.shouldPush(to: "/chat/room/\(place.roomInfo?.uuid ?? "")")
        } else {
            self.showInfoAlert(title: "Предупреждение", message: "Вы не находитесь в этом заведении", onAccept: nil)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        viewModel.myLocation = locations.last! as CLLocation
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        labelsView.updateCoordinates()
        labelsView.isHidden = viewModel.isMyLocationVisible.value
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        labelsView.isHidden = gesture
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        labelsView.isHidden = true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard viewModel.isMyLocationVisible.value  else { return false }
            
        tappedPinInRadius(marker: marker)
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //hide place card in case showMyLocation is off
        if !viewModel.isMyLocationVisible.value {
            mapView.animate(toZoom: 15.0)
            hideCollectionView()
        }
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        return false
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        guard let cluster = clusterItem as? ClusterItem else { return false }
        
        guard !viewModel.isMyLocationVisible.value else { return false }
        
        mapView.animate(to: GMSCameraPosition(latitude: cluster.position.latitude, longitude: cluster.position.longitude, zoom: 16.5))
        tappedSinglePlacePin(atIndex: cluster.id)
        
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
        let place = viewModel.places[indexPath.row]
        cell.configure(with: place) { [weak self] in
            self?.goToLiveChat(in: place)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = Storyboard.placeProfileViewController() as! PlaceProfileViewController
        vc.viewModel = PlaceProfileViewModel(place: viewModel.places[indexPath.row])
        present(controller: vc, presntationType: .push, completion: nil)
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

extension MapViewController: ControllerPresenterDelegate {
    func present(controller: UIViewController, presntationType: PresentationType, completion: VoidBlock?) {
        switch presntationType {
        case .push:
            navigationController?.pushViewController(controller, animated: true)
        case .present:
            present(controller, animated: true, completion: nil)
        }
    }
}
