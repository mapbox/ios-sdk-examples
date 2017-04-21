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
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // Substitute a custom view for the user location annotation. This custom view is created below.
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CustomUserLocationAnnotationView()
        }
        return nil
    }
}

// Create subclass of MGLUserLocationAnnotationView.
class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    let size: CGFloat = 25
    var arrowSize: CGFloat!
    var dot: CALayer!
    var arrow: CAShapeLayer!
    
    // -update is a method inherited from MGLUserLocationAnnotationView. It updates the appearance of the user location annotation when needed.
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: size, height: size)
            return setNeedsLayout()
        }
        // Check whether the user's location is a valid CLLocationCoordinate2D. This can be called many times a second, so be careful to keep it lightweight.
        if CLLocationCoordinate2DIsValid(self.userLocation!.coordinate) {
            setupLayers()
            updateHeading()
        }
    }
    
    private func updateHeading() {
        // Show the heading arrow, if the heading of the user is being tracked.
        if let heading = userLocation!.heading, mapView?.userTrackingMode == .followWithHeading {
            arrow.isHidden = false
            
            // Rotate the arrow according to the user’s heading.
            let rotation = CGAffineTransform.identity.rotated(
                by: -MGLRadiansFromDegrees(mapView!.direction - heading.trueHeading))
            layer.setAffineTransform(rotation)
        } else {
            arrow.isHidden = true
        }
    }
    
    private func setupLayers() {
        setupDot()
        setupArrow()
    }
    
    private func setupDot() {
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
    }
    
    private func setupArrow() {
        if arrow == nil {
            arrowSize = size / 2.5
            arrow = CAShapeLayer()
            arrow.path = arrowPath()
            arrow.frame = CGRect(x: 0, y: 0, width: arrowSize, height: arrowSize)
            arrow.position = CGPoint(x: size / 2, y: size / -4.5)
            arrow.fillColor = super.tintColor.cgColor
            layer.addSublayer(arrow)
        }
    }

    private func arrowPath() -> CGPath {
        // Draw an arrow.
        
        let max: CGFloat = arrowSize
        
        let top = CGPoint(x: max * 0.5, y: max * 0.4)
        let left = CGPoint(x: 0, y: max)
        let right = CGPoint(x: max, y: max)
        let center = CGPoint(x: max * 0.5, y: max * 0.8)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: top)
        bezierPath.addLine(to: left)
        bezierPath.addQuadCurve(to: right, controlPoint: center)
        bezierPath.addLine(to: top)
        bezierPath.close()
        return bezierPath.cgPath
    }
}
