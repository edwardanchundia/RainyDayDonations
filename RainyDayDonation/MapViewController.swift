//
//  MapViewController.swift
//  RainyDayDonation
//
//  Created by Edward Anchundia on 1/11/17.
//  Copyright © 2017 Margaret Ikeda, Simone Grant, Edward Anchundia, Miti Shah. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    var classroomArray = [Classroom]()
    var annotations = [MGLPointAnnotation]()
    var userLatitude: Float = 40.776104
    var userLongitude: Float = -73.920822
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locMan.distanceFilter = 50.0
        return locMan
    }()
    let geocoder: CLGeocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Views
        setupViews()
        setupViewHierarchy()
        //Set starting location
        let initialLocation = CLLocation(latitude: CLLocationDegrees(userLatitude), longitude: CLLocationDegrees(userLongitude))
        centerMapOnLocation(initialLocation)
        //Delegates
        locationManager.delegate = self
        mapView.delegate = self
        //Data Call
        loadData()
    }
    
    func setupViews() {
        //MapView
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = MGLStyle.lightStyleURL(withVersion: 9)
        mapView.tintColor = UIColor.blue
        
        //new search here button
        let searchHereButton = UIButton()
        mapView.addSubview(searchHereButton)
        let image = UIImage(named: "color")
        searchHereButton.setBackgroundImage(image, for: .normal)
        searchHereButton.setTitle("Search Here", for: .normal)
        searchHereButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin)
        searchHereButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        searchHereButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(mapView.snp.centerX)
            make.bottom.equalTo(mapView.snp.bottom).offset(-85)
            make.width.equalTo(125)
            make.height.equalTo(35)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(jumpToProfile))
    }
    
    //MARK: - View Hierarchy
    
    func setupViewHierarchy() {
        view.addSubview(mapView)
        self.edgesForExtendedLayout = []
    }
    
    func jumpToProfile() {
        let profileViewController = ProfileViewController()
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func searchButtonPressed(sender: UIButton!) {
        print("Im pressed")
        loadData()
    }
    
    func loadData() {
        let APIEndpoint = "https://api.donorschoose.org/common/json_feed.html?APIKey=DONORSCHOOSE&centerLat=\(userLatitude)&centerLng=\(userLongitude)&max=40"
        APIRequestManager.manager.getData(endPoint: APIEndpoint) { (data: Data?) in
            if data != nil {
                self.classroomArray = Classroom.getClassrooms(data: data!)!
                DispatchQueue.main.async {
                    self.loadAnnotations()
                }
            }
        }
    }
    
    func loadAnnotations() {
        for dict in classroomArray {
            let latitude = CLLocationDegrees(Double(dict.lat)!)
            let longitude = CLLocationDegrees(Double(dict.long)!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dict.title
            let school = dict.schoolName
            let proposal = dict.proposalURL
            let annotations = LocationMapAnnotation(name: name, school: school, url: proposal, coordinate: coordinate)
            annotations.coordinate = coordinate
            annotations.title = name
            annotations.subtitle = school
            mapView.addAnnotation(annotations)
            mapView.selectAnnotation(annotations, animated: true)
        }
    }
    
    //MARK: - CLLocation
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
            manager.stopUpdatingLocation()
        case .denied, .restricted:
            print("Authorization denied or restricted")
        case .notDetermined:
            print("Authorization undetermined")
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.setCenter(coordinateRegion, zoomLevel: 13, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let validLocation: CLLocation = locations.last else { return }
        let locationValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        userLatitude =  Float(locationValue.latitude)
        userLongitude = Float(locationValue.longitude)
        
        geocoder.reverseGeocodeLocation(validLocation) { (placemarks: [CLPlacemark]?, error: Error?) in
            //error handling
            if error != nil {
                dump(error!)
            }
            
            guard let validPlaceMarks: [CLPlacemark] = placemarks,
                let validPlace: CLPlacemark = validPlaceMarks.last else { return }
                print(validPlace)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error encountered")
        dump(error)
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        let newlogitude = center.longitude
        let newlatitude = center.latitude
        print("log = \(newlogitude), lat = \(newlatitude)")
        userLongitude = Float(newlogitude)
        userLatitude = Float(newlatitude)
    }
    
    //MARK: - MGLAnnotations
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        print(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "schoolPin")
        if annotationImage == nil {
            let image = UIImage(named: "rainy")!
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "schoolPin")
        }
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        let vc = ProjectPageViewController()
        if let annotationClicked = annotation as? LocationMapAnnotation {
            vc.project = annotationClicked
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Views
    
    internal var mapView: MGLMapView = {
        let mapView = MGLMapView()
        return mapView
    }()
    
    
}
