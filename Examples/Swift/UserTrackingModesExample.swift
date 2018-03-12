import Mapbox

@objc(UserTrackingModesExample_Swift)

class UserTrackingModesExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    @IBOutlet var button: UserLocationButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        // The user location annotation takes its color from the map view's tint color.
        mapView.tintColor = .red
        mapView.attributionButton.tintColor = .lightGray
        
        view.addSubview(mapView)
        
        setupLocationButton()
        mapView.userTrackingMode = .none
    }
    
    @IBAction func locationButtonTapped(sender: UserLocationButton) {
        var mode: MGLUserTrackingMode
        
        switch (mapView.userTrackingMode) {
        case .none:
            mode = .follow
            break
        case .follow:
            mode = .followWithHeading
            break
        case .followWithHeading:
            mode = .followWithCourse
            break
        case .followWithCourse:
            mode = .none
            break
        }
        
        mapView.userTrackingMode = mode
        sender.updateArrowForTrackingMode(mode: mode)
    }
    
    func setupLocationButton() {
        button = UserLocationButton(buttonSize: 80)
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        button.tintColor = mapView.tintColor
        view.addSubview(button)
        
        // Do some basic auto layout.
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: button.frame.size.height),
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: button.frame.size.width)
        ]
        
        view.addConstraints(constraints)
    }
}

// MARK: - Custom UIButton subclass

class UserLocationButton : UIButton {
    private var arrow: CAShapeLayer?
    private let buttonSize: CGFloat
    
    init(buttonSize: CGFloat) {
        self.buttonSize = buttonSize
        
        super.init(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))

        self.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.layer.cornerRadius = 4
        
        let arrow = CAShapeLayer()
        
        arrow.path = arrowPath()
        arrow.lineWidth = 2
        arrow.lineJoin = kCALineJoinRound
        arrow.bounds = CGRect(x: 0, y: 0, width: buttonSize / 2, height: buttonSize / 2)
        arrow.position = CGPoint(x: buttonSize / 2, y: buttonSize / 2)
        arrow.shouldRasterize = true
        arrow.rasterizationScale = UIScreen.main.scale
        arrow.drawsAsynchronously = true
        
        self.arrow = arrow
        
        updateArrowForTrackingMode(mode: .none)
        
        layer.addSublayer(self.arrow!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrowPath() -> CGPath {
        let max: CGFloat = buttonSize / 2
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: max * 0.5, y: 0))
        bezierPath.addLine(to: CGPoint(x: max * 0.1, y: max))
        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: max * 0.65))
        bezierPath.addLine(to: CGPoint(x: max * 0.9, y: max))
        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: 0))
        bezierPath.close()
        
        return bezierPath.cgPath
    }
    
    func updateArrowForTrackingMode(mode: MGLUserTrackingMode) {
        let activePrimaryColor = UIColor.red
        let disabledPrimaryColor = UIColor.clear
        let disabledSecondaryColor = UIColor.white
        let rotatedArrow = CGFloat(0.66)
        
        switch mode {
        case .none:
            updateArrow(with: disabledPrimaryColor, strokeColor: disabledSecondaryColor, rotation: 0)
            break
        case .follow:
            updateArrow(with: disabledPrimaryColor, strokeColor: activePrimaryColor, rotation: 0)
            break
        case .followWithHeading:
            updateArrow(with: activePrimaryColor, strokeColor: activePrimaryColor, rotation: rotatedArrow)
            break
        case .followWithCourse:
            updateArrow(with: activePrimaryColor, strokeColor: activePrimaryColor, rotation: 0)
            break
        }
    }
    
    func updateArrow(with fillColor: UIColor, strokeColor: UIColor, rotation: CGFloat) {
        
        guard let arrow = arrow else { return }
        
        arrow.fillColor = fillColor.cgColor
        arrow.strokeColor = strokeColor.cgColor
        arrow.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))
        
        layoutIfNeeded()
    }
}
