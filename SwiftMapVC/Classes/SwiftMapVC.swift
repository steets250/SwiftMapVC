//
//  SwiftMapVC.swift
//
//  Created by Steven Steiner on 08/19/2017.
//  Copyright (c) 2017 steets250. All rights reserved.
//

import CoreLocation
import MapKit

public class SwiftMapVC: UIViewController {
    var storedStatusColor: UIBarStyle?
    var buttonColor: UIColor?
    var titleColor: UIColor?
    var closing: Bool! = false
    var locationManager: CLLocationManager!
    
    lazy var mapView: MKMapView = {
        var tempMapView = MKMapView(frame: UIScreen.main.bounds)
        return tempMapView
    }()
    
    var pinTitle: String!
    var pageTitle: String!
    var latitude: Double!
    var longitude: Double!
    
    ////////////////////////////////////////////////
    
    public convenience init(room: String, building: String, floor: Int, latitude: Double, longitude: Double) {
        self.init()
        self.pinTitle = room
        if floor == 0 {
            self.pageTitle = building
        } else if floor == 1 {
            self.pageTitle = building + " - 1st Floor"
        } else if floor == 2 {
            self.pageTitle = building + " - 2nd Floor"
        }
        self.latitude = latitude
        self.longitude = longitude
    }
    
    ////////////////////////////////////////////////
    // View Lifecycle
    
    override public func loadView() {
        view = mapView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsBuildings = true
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = pinTitle
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = location
        mapCamera.pitch = 45
        mapCamera.altitude = 500
        mapCamera.heading = 329
        mapView.camera = mapCamera
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        assert(self.navigationController != nil, "SVMapViewController needs to be contained in a UINavigationController. If you are presenting SVMapViewController modally, use SVModalMapViewController instead.")
        
        if pageTitle != pinTitle {
            let navBarTitle = UILabel()
            navBarTitle.text = pageTitle
            navBarTitle.sizeToFit()
            
            if presentingViewController == nil {
                if let titleAttributes = navigationController!.navigationBar.titleTextAttributes {
                    navBarTitle.textColor = NSAttributedString.Key.strokeColor as! UIColor //titleAttributes["NSColor"] as! UIColor
                }
            } else {
                navBarTitle.textColor = self.titleColor
            }
            navBarTitle.shadowOffset = CGSize(width: 0, height: 1)
            navBarTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)
            
            navigationItem.titleView = navBarTitle
        }
        
        super.viewWillAppear(true)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    @objc func doneButtonTapped() {
        closing = true
        UINavigationBar.appearance().barStyle = storedStatusColor!
        self.dismiss(animated: true, completion: nil)
    }
    
    class func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return UIImage(named: named, in: Bundle(for: SwiftMapVC.classForCoder()), compatibleWith: nil)
        }
        return image
    }
}
