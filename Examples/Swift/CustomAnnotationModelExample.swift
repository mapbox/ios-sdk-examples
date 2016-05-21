//
//  CustomAnnotationModelExample.swift
//  Examples
//
//  Created by Jason Wray on 5/20/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(CustomAnnotationModelExample_Swift)

class CustomAnnotationModelExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.styleURL = MGLStyle.lightStyleURLWithVersion(9)
        mapView.tintColor = .darkGrayColor()
        mapView.zoomLevel = 1
        mapView.delegate = self
        view.addSubview(mapView)

        // Point Annotation
        let point = CustomPointAnnotation(coordinate: CLLocationCoordinate2DMake(0, 0),
                                          title: "Custom Point Annotation",
                                          subtitle: nil)
        // Set the custom `image` and `reuseIdentifier` properties, later used in the `mapView:imageForAnnotation:` delegate method.
        point.reuseIdentifier = "yeOldeGreyDot"
        point.image = dotWithSize(20)

        // Polyline
        // Create a coordinates array with all of the coordinates for our polyline.
        var coordinates = [
            CLLocationCoordinate2DMake(35, -25),
            CLLocationCoordinate2DMake(20, -30),
            CLLocationCoordinate2DMake( 0, -25),
            CLLocationCoordinate2DMake(-15,  0),
            CLLocationCoordinate2DMake(-45, 10),
            CLLocationCoordinate2DMake(-45, 40),
        ]

        let polyline = CustomPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        // Set the custom `color` property, later used in the `mapView:strokeColorForShapeAnnotation:` delegate method.
        polyline.color = .darkGrayColor()

        // Add both annotations to the map.
        mapView.addAnnotations([point, polyline])
    }

    func dotWithSize(size: CGFloat) -> (UIImage) {
        let rect = CGRectMake(0, 0, size, size)
        let strokeWidth: CGFloat = 1

        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)

        let ovalPath = UIBezierPath(ovalInRect: CGRectInset(rect, strokeWidth, strokeWidth))
        UIColor.darkGrayColor().setFill()
        ovalPath.fill()

        UIColor.whiteColor().setStroke()
        ovalPath.lineWidth = strokeWidth
        ovalPath.stroke()

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    // MARK: - MGLMapViewDelegate methods

    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let point = annotation as? CustomPointAnnotation,
            image = point.image,
            reuseIdentifier = point.reuseIdentifier {

            if let annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(reuseIdentifier) {
                // The annotatation image has already been cached, just reuse it.
                return annotationImage
            } else {
                // Create a new annotation image.
                return MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
            }
        }

        // Fallback to the default marker image.
        return nil
    }

    func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        if let annotation = annotation as? CustomPolyline {
            // Return orange if the polyline does not have a custom color.
            return annotation.color ?? .orangeColor()
        }

        // Fallback to the default tint color.
        return mapView.tintColor
    }

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
