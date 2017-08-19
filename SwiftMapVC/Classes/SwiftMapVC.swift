//
//  SwiftMapVC.swift
//
//  Created by Myles Ringle on 24/06/2015.
//  Transcribed from code used in SVMapViewController.
//  Copyright (c) 2015 Myles Ringle & Sam Vermette. All rights reserved.
//

import CoreLocation
import MapKit

public class SwiftMapVC: UIViewController {
    var buildings = [Building]()
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
    var latitude: Double!
    var longitude: Double!
    var current: Bool!

    ////////////////////////////////////////////////

    public convenience init(location: String, current: Bool) {
        self.init()
        buildings = appDelegate.buildingData
        if let temp = buildings.filter({$0.name == location}).first {
            self.current = current
            self.pinTitle = temp.name
            self.latitude = temp.latitude
            self.longitude = temp.longitude
        }
    }

    ////////////////////////////////////////////////
    // View Lifecycle

    override public func loadView() {
        view = mapView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let uidtgr = UITapGestureRecognizer(target: self, action: #selector(revealRegionDetailsWithLongPressOnMap))
        uidtgr.numberOfTapsRequired = 2
        uidtgr.numberOfTouchesRequired = 1

        mapView.addGestureRecognizer(uidtgr)
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsBuildings = true

        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )

        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }

    override public func viewWillAppear(_ animated: Bool) {
        assert(self.navigationController != nil, "SVMapViewController needs to be contained in a UINavigationController. If you are presenting SVMapViewController modally, use SVModalMapViewController instead.")

        let navBarTitle = UILabel()
        navBarTitle.text = pinTitle
        navBarTitle.sizeToFit()

        if presentingViewController == nil {
            if let titleAttributes = navigationController!.navigationBar.titleTextAttributes {
                navBarTitle.textColor = titleAttributes["NSColor"] as! UIColor
            }
        } else {
            navBarTitle.textColor = self.titleColor
        }
        navBarTitle.shadowOffset = CGSize(width: 0, height: 1)
        navBarTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)

        navigationItem.titleView = navBarTitle

        super.viewWillAppear(true)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }

    //Diagnostic
    func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
    }
    //End Diagnostic

    func doneButtonTapped() {
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
