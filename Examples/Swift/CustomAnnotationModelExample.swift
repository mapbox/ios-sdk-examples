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

        // Add the polyline to the map. Note that this method name is singular.
        mapView.addAnnotation(polyline)

        // Point Annotations
        // Add a custom point annotation for every coordinate (vertex) in the polyline.
        var pointAnnotations = [CustomPointAnnotation]()
        for coordinate in coordinates {
            let count = pointAnnotations.count + 1
            let point = CustomPointAnnotation(coordinate: coordinate,
                                              title: "Custom Point Annotation \(count)",
                                              subtitle: nil)

            // Set the custom `image` and `reuseIdentifier` properties, later used in the `mapView:imageForAnnotation:` delegate method.
            // Create a unique reuse identifier for each new annotation image.
            point.reuseIdentifier = "customAnnotation\(count)"
            // This dot image grows in size as more annotations are added to the array.
            point.image = dot(size:5 * count)

            // Append each annotation to the array, which will be added to the map all at once.
            pointAnnotations.append(point)
        }

        // Add the point annotations to the map. This time the method name is plural.
        // If you have multiple annotations to add, batching their addition to the map is more efficient.
        mapView.addAnnotations(pointAnnotations)
    }

    func dot(size size: Int) -> UIImage {
        let floatSize = CGFloat(size)
        let rect = CGRectMake(0, 0, floatSize, floatSize)
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
