//
//  AnnotationMovementExample.swift
//  Examples
//
//  Created by Jason Wray on 7/19/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(AnnotationMovementExample_Swift)

// Example view controller
class AnnotationMovementExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var path: [CLLocationCoordinate2D]!
    var point: MGLPointAnnotation?
    var pointCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.styleURL = MGLStyle.outdoorsStyleURLWithVersion(9)
        mapView.delegate = self
        view.addSubview(mapView)

        drawPolyline()
    }

    // MARK: - MGLMapViewDelegate methods

    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }

        // For better performance, always try to reuse existing annotations. To use multiple different annotation views, change the reuse identifier for each.
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("bicycle") {
            return annotationView
        } else {
            return MoveableAnnotationView(reuseIdentifier: "bicycle", size: 10)
        }
    }

    func moveBicycleAlongPath() {
        if path == nil {
            return
        }

        if point == nil {
            point = MGLPointAnnotation()
            point!.coordinate = path.first!
            mapView.addAnnotation(point!)

            let _ = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(self.moveBicycleAlongPath), userInfo: nil, repeats: true)

            return
        }

        if pointCount == path.count {
            pointCount = 0
        }

        point?.coordinate = path[pointCount]
        pointCount += 1

        mapView.setCenterCoordinate((point?.coordinate)!, animated: true)
    }

    func drawPolyline() {
        // Parsing GeoJSON can be CPU intensive, do it on a background thread.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Get the path for london.geojson in the app’s bundle.
            let jsonPath = NSBundle.mainBundle().pathForResource("london", ofType: "geojson")
            let jsonData = NSData(contentsOfFile: jsonPath!)

            do {
                // Load and serialize the GeoJSON into a dictionary filled with properly-typed objects.
                if let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: []) as? NSDictionary {

                    // Load the `features` array for iteration
                    if let features = jsonDict["features"] as? NSArray {
                        for feature in features {
                            if let feature = feature as? NSDictionary {
                                if let geometry = feature["geometry"] as? NSDictionary {
                                    if geometry["type"] as? String == "LineString" {
                                        // Create an array to hold the formatted coordinates for our line
                                        var coordinates: [CLLocationCoordinate2D] = []

                                        if let locations = geometry["coordinates"] as? NSArray {
                                            // Iterate over line coordinates, stored in GeoJSON as many lng, lat arrays.
                                            for location in locations {
                                                // Make a CLLocationCoordinate2D with the lat, lng
                                                let coordinate = CLLocationCoordinate2DMake(location[1].doubleValue, location[0].doubleValue)

                                                // Add coordinate to coordinates array
                                                coordinates.append(coordinate)
                                            }
                                        }

                                        let line = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))

                                        // Add the annotation on the main thread
                                        dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                                            self.mapView.addAnnotation(line)
                                            self.mapView.showAnnotations([line], edgePadding: UIEdgeInsetsMake(10, 10, 10, 10), animated: false)
                                            self.path = coordinates
                                            self.moveBicycleAlongPath()
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print("GeoJSON parsing failed")
            }
        })
    }
}

//
// MGLAnnotationView subclass
class MoveableAnnotationView: MGLAnnotationView {
    init(reuseIdentifier: String, size: CGFloat) {
        super.init(reuseIdentifier: reuseIdentifier)

        // This property prevents the annotation from changing size when the map is tilted.
        scalesWithViewingDistance = false

        // Begin setting up the view.
        frame = CGRectMake(0, 0, size, size)

        backgroundColor = .darkGrayColor()

        // Use CALayer’s corner radius to turn this view into a circle.
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

    override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
        if event == "position" {
            let animation = CABasicAnimation(keyPath: event)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.speed = 0.5
            return animation
        } else {
            return super.actionForLayer(layer, forKey: event)
        }
    }

}
