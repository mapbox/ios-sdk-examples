import Mapbox

@objc(UserLocationAnnotationExample_Swift)

class UserLocationAnnotationExample_Swift: UIViewController, MGLMapViewDelegate {
    let point = MGLPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        // Enable heading tracking mode so that the arrow will appear.
        mapView.userTrackingMode = .followWithHeading

        // Enable the permanent heading indicator, which will appear when the tracking mode is not `.followWithHeading`.
        mapView.showsUserHeadingIndicator = true

        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // Substitute our custom view for the user location annotation. This custom view is defined below.
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CustomUserLocationAnnotationView()
        }
        return nil
    }

    // Optional: tap the user location annotation to toggle heading tracking mode.
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if mapView.userTrackingMode != .followWithHeading {
            mapView.userTrackingMode = .followWithHeading
        } else {
            mapView.resetNorth()
        }

        // We're borrowing this method as a gesture recognizer, so reset selection state.
        mapView.deselectAnnotation(annotation, animated: false)
    }
}

// Create a subclass of MGLUserLocationAnnotationView.
class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    let size: CGFloat = 48
    var dot: CALayer!
    var arrow: CAShapeLayer!

    // -update is a method inherited from MGLUserLocationAnnotationView. It updates the appearance of the user location annotation when needed. This can be called many times a second, so be careful to keep it lightweight.
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: size, height: size)
            return setNeedsLayout()
        }

        // Check whether we have the user’s location yet.
        if CLLocationCoordinate2DIsValid(userLocation!.coordinate) {
            setupLayers()
            updateHeading()
        }
    }

    private func updateHeading() {
        // Show the heading arrow, if the heading of the user is available.
        if let heading = userLocation!.heading?.trueHeading {
            arrow.isHidden = false

            // Get the difference between the map’s current direction and the user’s heading, then convert it from degrees to radians.
            let rotation: CGFloat = -MGLRadiansFromDegrees(mapView!.direction - heading)

            // If the difference would be perceptible, rotate the arrow.
            if abs(rotation) > 0.01 {
                // Disable implicit animations of this rotation, which reduces lag between changes.
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                arrow.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))
                CATransaction.commit()
            }
        } else {
            arrow.isHidden = true
        }
    }

    private func setupLayers() {
        // This dot forms the base of the annotation.
        if dot == nil {
            dot = CALayer()
            dot.bounds = CGRect(x: 0, y: 0, width: size, height: size)

            // Use CALayer’s corner radius to turn this layer into a circle.
            dot.cornerRadius = size / 2
            dot.backgroundColor = super.tintColor.cgColor
            dot.borderWidth = 4
            dot.borderColor = UIColor.white.cgColor
            layer.addSublayer(dot)
        }

        // This arrow overlays the dot and is rotated with the user’s heading.
        if arrow == nil {
            arrow = CAShapeLayer()
            arrow.path = arrowPath()
            arrow.frame = CGRect(x: 0, y: 0, width: size / 2, height: size / 2)
            arrow.position = CGPoint(x: dot.frame.midX, y: dot.frame.midY)
            arrow.fillColor = dot.borderColor
            layer.addSublayer(arrow)
        }
    }

    // Calculate the vector path for an arrow, for use in a shape layer.
    private func arrowPath() -> CGPath {
        let max: CGFloat = size / 2
        let pad: CGFloat = 3

        let top =    CGPoint(x: max * 0.5, y: 0)
        let left =   CGPoint(x: 0 + pad,   y: max - pad)
        let right =  CGPoint(x: max - pad, y: max - pad)
        let center = CGPoint(x: max * 0.5, y: max * 0.6)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: top)
        bezierPath.addLine(to: left)
        bezierPath.addLine(to: center)
        bezierPath.addLine(to: right)
        bezierPath.addLine(to: top)
        bezierPath.close()

        return bezierPath.cgPath
    }
}
