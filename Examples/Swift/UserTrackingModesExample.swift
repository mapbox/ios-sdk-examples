import Mapbox

@objc(UserTrackingModesExample_Swift)

class UserTrackingModesExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var userLocationButton: UserLocationButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        // The user location annotation takes its color from the map view's tint color.
        mapView.tintColor = .red
        mapView.attributionButton.tintColor = .lightGray

        // Enable the always-on heading indicator for the user location annotation.
        mapView.showsUserHeadingIndicator = true

        view.addSubview(mapView)

        // Create button to allow user to change the tracking mode.
        setupLocationButton()
    }

    // Update the button state when the user tracking mode updates or resets.
    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
        guard let userLocationButton = userLocationButton else { return }
        userLocationButton.updateArrowForTrackingMode(mode: mode)
    }

    // Update the user tracking mode when the user toggles through the
    // user tracking mode button.
    @IBAction func locationButtonTapped(sender: UserLocationButton) {
        var mode: MGLUserTrackingMode

        switch (mapView.userTrackingMode) {
        case .none:
            mode = .follow
        case .follow:
            mode = .followWithHeading
        case .followWithHeading:
            mode = .followWithCourse
        case .followWithCourse:
            mode = .none
        @unknown default:
            fatalError("Unknown user tracking mode")
        }

        mapView.userTrackingMode = mode
    }

    // Button creation and autolayout setup
    func setupLocationButton() {
        let userLocationButton = UserLocationButton(buttonSize: 80)
        userLocationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        userLocationButton.tintColor = mapView.tintColor

        // Setup constraints such that the button is placed within
        // the upper left corner of the view.
        userLocationButton.translatesAutoresizingMaskIntoConstraints = false

        var leadingConstraintSecondItem: AnyObject
        if #available(iOS 11.0, *) {
            leadingConstraintSecondItem = view.safeAreaLayoutGuide
        } else {
            leadingConstraintSecondItem = view
        }

        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: userLocationButton, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: userLocationButton, attribute: .leading, relatedBy: .equal, toItem: leadingConstraintSecondItem, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: userLocationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: userLocationButton.frame.size.height),
            NSLayoutConstraint(item: userLocationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: userLocationButton.frame.size.width)
        ]

        view.addSubview(userLocationButton)
        view.addConstraints(constraints)

        self.userLocationButton = userLocationButton
    }
}

// MARK: - Custom UIButton subclass

class UserLocationButton: UIButton {
    private var arrow: CAShapeLayer?
    private let buttonSize: CGFloat

    // Initializer to create the user tracking mode button
    init(buttonSize: CGFloat) {
        self.buttonSize = buttonSize
        super.init(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        self.layer.cornerRadius = 4

        let arrow = CAShapeLayer()
        arrow.path = arrowPath()
        arrow.lineWidth = 2
        arrow.lineJoin = CAShapeLayerLineJoin.round
        arrow.bounds = CGRect(x: 0, y: 0, width: buttonSize / 2, height: buttonSize / 2)
        arrow.position = CGPoint(x: buttonSize / 2, y: buttonSize / 2)
        arrow.shouldRasterize = true
        arrow.rasterizationScale = UIScreen.main.scale
        arrow.drawsAsynchronously = true

        self.arrow = arrow

        // Update arrow for initial tracking mode
        updateArrowForTrackingMode(mode: .none)
        layer.addSublayer(self.arrow!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Create a new bezier path to represent the tracking mode arrow,
    // making sure the arrow does not get drawn outside of the
    // frame size of the UIButton.
    private func arrowPath() -> CGPath {
        let bezierPath = UIBezierPath()
        let max: CGFloat = buttonSize / 2
        bezierPath.move(to: CGPoint(x: max * 0.5, y: 0))
        bezierPath.addLine(to: CGPoint(x: max * 0.1, y: max))
        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: max * 0.65))
        bezierPath.addLine(to: CGPoint(x: max * 0.9, y: max))
        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: 0))
        bezierPath.close()

        return bezierPath.cgPath
    }

    // Update the arrow's color and rotation when tracking mode is changed.
    func updateArrowForTrackingMode(mode: MGLUserTrackingMode) {
        let activePrimaryColor = UIColor.red
        let disabledPrimaryColor = UIColor.clear
        let disabledSecondaryColor = UIColor.black
        let rotatedArrow = CGFloat(0.66)

        switch mode {
        case .none:
            updateArrow(fillColor: disabledPrimaryColor, strokeColor: disabledSecondaryColor, rotation: 0)
        case .follow:
            updateArrow(fillColor: disabledPrimaryColor, strokeColor: activePrimaryColor, rotation: 0)
        case .followWithHeading:
            updateArrow(fillColor: activePrimaryColor, strokeColor: activePrimaryColor, rotation: rotatedArrow)
        case .followWithCourse:
            updateArrow(fillColor: activePrimaryColor, strokeColor: activePrimaryColor, rotation: 0)
        @unknown default:
            fatalError("Unknown user tracking mode")
        }
    }

    func updateArrow(fillColor: UIColor, strokeColor: UIColor, rotation: CGFloat) {
        guard let arrow = arrow else { return }
        arrow.fillColor = fillColor.cgColor
        arrow.strokeColor = strokeColor.cgColor
        arrow.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))

        // Re-center the arrow within the button if rotated
        if rotation > 0 {
            arrow.position = CGPoint(x: buttonSize / 2 + 2, y: buttonSize / 2 - 2)
        }

        layoutIfNeeded()
    }
}
