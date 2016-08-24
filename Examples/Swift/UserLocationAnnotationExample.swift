//
//  UserLocationAnnotationExample.swift
//  Examples
//
//  Created by Jason Wray on 8/18/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Foundation

import Mapbox

@objc(UserLocationAnnotationExample_Swift)

class UserLocationAnnotationExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.delegate = self

        mapView.userTrackingMode = .FollowWithHeading

        view.addSubview(mapView)
    }

    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CustomUserLocationAnnotationView()
        }

        return nil
    }
}

class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    let size: CGFloat = 25
    var arrowSize: CGFloat!

    var dot: CALayer!
    var arrow: CAShapeLayer!

    override func update() {
        if CGRectIsNull(frame) {
            frame = CGRectMake(0, 0, size, size)
        }

        if CLLocationCoordinate2DIsValid(self.userLocation!.coordinate) {
            setupLayers()
            updateHeading()
        }
    }

    private func updateHeading() {
        if let heading = userLocation!.heading where mapView?.userTrackingMode == .FollowWithHeading {
            arrow.hidden = false

            let rotation = CGAffineTransformRotate(
                CGAffineTransformIdentity,
                -MGLRadiansFromDegrees(mapView!.direction - heading.trueHeading))
            layer.setAffineTransform(rotation)
        } else {
            arrow.hidden = true
        }
    }

    private func setupLayers() {
        setupDot()
        setupArrow()
    }

    private func setupDot() {
        if dot == nil {
            dot = CALayer()
            dot.bounds = CGRectMake(0, 0, size, size)
            dot.position = CGPointMake(super.bounds.size.width / 2, super.bounds.size.height / 2)
            dot.shouldRasterize = true
            dot.rasterizationScale = UIScreen.mainScreen().scale
            dot.drawsAsynchronously = true

            dot.cornerRadius = size / 2
            dot.backgroundColor = super.tintColor.CGColor ?? UIColor.redColor().CGColor
            dot.borderWidth = 2
            dot.borderColor = UIColor.whiteColor().CGColor
            dot.shadowColor = UIColor.blackColor().CGColor
            dot.shadowOffset = CGSizeMake(0, 0)

            layer.addSublayer(dot)
        }
    }

    private func setupArrow() {
        if arrow == nil {
            arrowSize = size / 2.5

            arrow = CAShapeLayer()
            arrow.path = arrowPath()
            arrow.bounds = CGRectMake(0, 0, arrowSize, size + (arrowSize * 2))
            arrow.position = CGPointMake(super.bounds.size.width / 2, 0)
            arrow.shouldRasterize = true
            arrow.rasterizationScale = UIScreen.mainScreen().scale
            arrow.drawsAsynchronously = true

            //arrow.borderWidth = 1
            //arrow.borderColor = UIColor(white: 0, alpha: 0.25).CGColor

            arrow.fillColor = super.tintColor.CGColor ?? UIColor.whiteColor().CGColor

            layer.addSublayer(arrow)
        }
    }

    private func arrowPath() -> CGPath {
        let max: CGFloat = arrowSize

        let top = CGPointMake(max * 0.5, max * 0.4)
        let left = CGPointMake(0, max)
        let right = CGPointMake(max, max)
        let center = CGPointMake(max * 0.5, max * 0.8)

        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(top)
        bezierPath.addLineToPoint(left)
        bezierPath.addQuadCurveToPoint(right, controlPoint: center)
        bezierPath.addLineToPoint(top)
        bezierPath.closePath()

        return bezierPath.CGPath
    }
}

