//
//  UserTrackingModesExample.swift
//  Examples
//
//  Created by Jason Wray on 6/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//
#if !swift(>=3.0)
    
import Mapbox

@objc(UserTrackingModesExample_Swift)

class UserTrackingModesExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    @IBOutlet var button: UserLocationButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURLWithVersion(9))
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.delegate = self

        mapView.tintColor = .redColor()
        mapView.attributionButton.tintColor = .lightGrayColor()

        view.addSubview(mapView)

        setupLocationButton()
    }

    func mapView(mapView: MGLMapView, didChangeUserTrackingMode mode: MGLUserTrackingMode, animated: Bool) {
        button.updateArrow(for: mode)
    }

    @IBAction func locationButtonTapped() {
        var mode: MGLUserTrackingMode

        switch (mapView.userTrackingMode) {
        case .None:
            mode = .Follow
            break
        case .Follow:
            mode = .FollowWithHeading
            break
        case .FollowWithHeading:
            mode = .FollowWithCourse
            break
        case .FollowWithCourse:
            mode = .None
            break
        }

        mapView.userTrackingMode = mode
    }

    func setupLocationButton() {
        button = UserLocationButton()
        button.addTarget(self, action: #selector(locationButtonTapped), forControlEvents: .TouchUpInside)
        button.tintColor = mapView.tintColor
        view.addSubview(button)

        // Do some basic auto layout.
        button.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: button.frame.size.height),
            NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: button.frame.size.width)
        ]

        view.addConstraints(constraints)
    }

}

class UserLocationButton : UIButton {
    private let size: CGFloat = 80
    private var arrow: CAShapeLayer?

    required init() {
        super.init(frame: CGRectMake(0, 0, size, size))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        layer.cornerRadius = 4

        layoutArrow()
    }

    private func layoutArrow() {
        if arrow == nil {
            let arrow = CAShapeLayer()
            arrow.path = arrowPath()
            arrow.bounds = CGRectMake(0, 0, size / 2, size / 2)
            arrow.position = CGPointMake(size / 2, size / 2)
            arrow.shouldRasterize = true
            arrow.rasterizationScale = UIScreen.mainScreen().scale
            arrow.drawsAsynchronously = true

            self.arrow = arrow
            updateArrow(for: .None)
            layer.addSublayer(self.arrow!)
        }
    }

    private func arrowPath() -> CGPath {
        let max: CGFloat = size / 2

        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(max * 0.5, 0))
        bezierPath.addLineToPoint(CGPointMake(max * 0.1, max))
        bezierPath.addLineToPoint(CGPointMake(max * 0.5, max * 0.65))
        bezierPath.addLineToPoint(CGPointMake(max * 0.9, max))
        bezierPath.addLineToPoint(CGPointMake(max * 0.5, 0))
        bezierPath.closePath()

        return bezierPath.CGPath
    }

    func updateArrow(for mode: MGLUserTrackingMode) {
        var stroke: CGColor
        switch (mode) {
        case .None:
            stroke = UIColor.whiteColor().CGColor
        case .Follow:
            stroke = tintColor.CGColor
        case .FollowWithHeading, .FollowWithCourse:
            stroke = UIColor.clearColor().CGColor
        }
        arrow!.strokeColor = stroke

        // Re-center the arrow, based on its current orientation.
        arrow!.position = (mode == .None || mode == .FollowWithCourse) ? CGPointMake(size / 2, size / 2) : CGPointMake(size / 2 + 2, size / 2 - 2)

        arrow!.fillColor = (mode == .None || mode == .Follow) ? UIColor.clearColor().CGColor : tintColor.CGColor

        let rotation: CGFloat = (mode == .Follow || mode == .FollowWithHeading) ? 0.66 : 0
        arrow!.setAffineTransform(CGAffineTransformRotate(CGAffineTransformIdentity, rotation))

        layoutIfNeeded()
    }
}
#endif
