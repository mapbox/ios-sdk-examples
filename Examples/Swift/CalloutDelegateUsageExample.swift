//
//  CalloutDelegateUsageExample.swift
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(CalloutDelegateUsageExample_Swift)

class CalloutDelegateUsageExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        view.addSubview(mapView)

        // remember to set the delegate (or much of this will not work)
        mapView.delegate = self

        addAnnotation()
    }

    func addAnnotation() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(35.03946, 135.72956)
        annotation.title = "Kinkaku-ji"
        annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"

        mapView.addAnnotation(annotation)

        // fit the map to the annotation(s)
        mapView.showAnnotations(mapView.annotations!, animated: false)

        // pop-up the callout view
        mapView.selectAnnotation(annotation, animated: true)
    }

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func mapView(mapView: MGLMapView, leftCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        if (annotation.title! == "Kinkaku-ji") {
            let label = UILabel(frame: CGRectMake(0, 0, 60, 50))
            label.textAlignment = .Right
            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
            label.text = "金閣寺"

            return label
        }

        return nil
    }

    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .DetailDisclosure)
    }

    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // hide the callout view
        mapView.deselectAnnotation(annotation, animated: false)

        UIAlertView(title: annotation.title!!, message: "A lovely (if touristy) place.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
    }
}
