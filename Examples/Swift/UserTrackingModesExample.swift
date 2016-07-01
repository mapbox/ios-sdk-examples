//
//  UserTrackingModesExample.swift
//  Examples
//
//  Created by Jason Wray on 6/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(UserTrackingModesExample_Swift)

class UserTrackingModesExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURLWithVersion(9))
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        view.addSubview(mapView)

        view.addSubview(locateButton())
    }

    override func viewDidAppear(animated: Bool) {
        //mapView.setTargetCoordinate(CLLocationCoordinate2D(latitude: 45, longitude: 122), animated: true)
    }

    func locateButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 60, 60)
        button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1)

        button.addTarget(self, action: Selector("locateUser"), forControlEvents: .TouchUpInside)

        return button
    }

    func locateUser() {
        mapView.userTrackingMode = .FollowWithCourse
    }

}
