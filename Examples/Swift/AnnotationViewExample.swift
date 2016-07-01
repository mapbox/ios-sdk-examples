//
//  AnnotationViewExample.swift
//  Examples
//
//  Created by Jason Wray on 6/23/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(AnnotationViewExample_Swift)

class AnnotationViewExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.styleURL = MGLStyle.lightStyleURLWithVersion(9)
        mapView.tintColor = .darkGrayColor()
        mapView.zoomLevel = 1
        mapView.delegate = self
        view.addSubview(mapView)

        let coordinates = [
            CLLocationCoordinate2DMake(0, -70),
            CLLocationCoordinate2DMake(0, -35),
            CLLocationCoordinate2DMake(0,  0),
            CLLocationCoordinate2DMake(0, 35),
            CLLocationCoordinate2DMake(0, 70),
        ]

        var pointAnnotations = [MGLPointAnnotation]()
        for coordinate in coordinates {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = "To drag this annotation, first tap and hold."
            pointAnnotations.append(point)
        }

        mapView.addAnnotations(pointAnnotations)
    }

    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }

        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("draggablePoint") {
            return annotationView
        } else {
            return CustomDraggableAnnotationView(reuseIdentifier: "draggablePoint", size: 50)
        }
    }

    func mapView(mapView: MGLMapView, didDragAnnotationView annotationView: MGLAnnotationView, toCoordinate coordinate: CLLocationCoordinate2D) {
        if let annotation = annotationView.annotation as? MGLPointAnnotation {
            // Leave this annotation at the final drag position.
            // If you do not manually update the coordinate, the annotation will return to its original position.
            annotation.coordinate = coordinate
        }
    }

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

// MGLAnnotationView subclass
class CustomDraggableAnnotationView : MGLAnnotationView {
    init(reuseIdentifier: String, size: CGFloat) {
        super.init(reuseIdentifier: reuseIdentifier)

        // `draggable` is a property of MGLAnnotationView, disabled by default.
        draggable = true

        // This property prevents the annotation from changing size when the map is tilted.
        scalesWithViewingDistance = false

        // Begin setting up the view.
        frame = CGRectMake(0, 0, size, size)

        backgroundColor = .darkGrayColor()

        // Use CALayer's corner radius to turn this view into a circle.
        layer.cornerRadius = size / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.1
    }

    // These two initializers are forced upon us by Swift.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //
    override func setDragState(dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)

        switch dragState {
        case .Starting:
            print("Starting", terminator: "")
            startDragging()
            break
        case .Dragging:
            print(".", terminator: "")
        case .Ending, .Canceling:
            print("Ending")
            endDragging()
            break
        case .None:
            return
        }
    }

    func startDragging() {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 0.8
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5)
        }, completion: nil)
    }

    func endDragging() {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 1
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
        }, completion: nil)
    }
}
