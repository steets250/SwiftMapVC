//
//  SwiftModalMapVC.swift
//
//  Created by Myles Ringle on 24/06/2015.
//  Transcribed from code used in SVMapViewController.
//  Copyright (c) 2015 Myles Ringle & Oliver Letterer. All rights reserved.
//

import UIKit

public class SwiftModalMapVC: UINavigationController {
    public enum SwiftModalMapVCTheme {
        case lightBlue, dark
    }
    
    public init(room: String, building: String, floor: Int, latitude: Double, longitude: Double, theme: SwiftModalMapVCTheme = .lightBlue) {
        let mapViewController = SwiftMapVC(room: room, building: building, floor: floor, latitude: latitude, longitude: longitude)
        mapViewController.storedStatusColor = UINavigationBar.appearance().barStyle
        let doneButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Dismiss"),
                                         style: UIBarButtonItem.Style.plain,
                                         target: mapViewController,
                                         action: #selector(SwiftMapVC.doneButtonTapped))
        switch theme {
        case .lightBlue:
            doneButton.tintColor = nil
            mapViewController.buttonColor = nil
            mapViewController.titleColor = .black
            UINavigationBar.appearance().barStyle = UIBarStyle.default
        case .dark:
            doneButton.tintColor = .white
            mapViewController.buttonColor = .white
            mapViewController.titleColor = .groupTableViewBackground
            UINavigationBar.appearance().barStyle = UIBarStyle.black
        }
        
        mapViewController.navigationItem.rightBarButtonItem = doneButton
        super.init(rootViewController: mapViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
}
