//
//  CustomCalloutView.swift
//  Examples
//
//  Created by Jason Wray on 3/11/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//
#if !swift(>=3.0)
    
import Mapbox

class CustomCalloutView: UIView, MGLCalloutView {
    var representedObject: MGLAnnotation
    lazy var leftAccessoryView = UIView()/* unused */
    lazy var rightAccessoryView = UIView()/* unused */
    weak var delegate: MGLCalloutViewDelegate?

    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0

    let mainBody: UIButton

    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        self.mainBody = UIButton(type: .System)

        super.init(frame: CGRectZero)

        backgroundColor = UIColor.clearColor()

        mainBody.backgroundColor = backgroundColorForCallout()
        mainBody.tintColor = UIColor.whiteColor()
        mainBody.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mainBody.layer.cornerRadius = 4.0

        addSubview(mainBody)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - MGLCalloutView API

    func presentCalloutFromRect(rect: CGRect, inView view: UIView, constrainedToView constrainedView: UIView, animated: Bool) {
        if !representedObject.respondsToSelector(Selector("title")) {
            return
        }

        view.addSubview(self)

        // Prepare title label
        mainBody.setTitle(representedObject.title!, forState: .Normal)
        mainBody.sizeToFit()

        if isCalloutTappable() {
            // Handle taps and eventually try to send them to the delegate (usually the map view)
            mainBody.addTarget(self, action: #selector(CustomCalloutView.calloutTapped), forControlEvents: .TouchUpInside)
        } else {
            // Disable tapping and highlighting
            mainBody.userInteractionEnabled = false
        }

        // Prepare our frame, adding extra space at the bottom for the tip
        let frameWidth = mainBody.bounds.size.width
        let frameHeight = mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRectMake(frameOriginX, frameOriginY, frameWidth, frameHeight)

        if animated {
            alpha = 0

            UIView.animateWithDuration(0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }

    func dismissCalloutAnimated(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animateWithDuration(0.2, animations: { [weak self] in
                    self?.alpha = 0
                }, completion: { [weak self] _ in
                    self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }

    // MARK: - Callout interaction handlers

    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.respondsToSelector(#selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }

    func calloutTapped() {
        if isCalloutTappable() && delegate!.respondsToSelector(#selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }

    // MARK: - Custom view styling

    func backgroundColorForCallout() -> UIColor {
        return UIColor.darkGrayColor()
    }

    override func drawRect(rect: CGRect) {
        // Draw the pointed tip at the bottom
        let fillColor = backgroundColorForCallout()

        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPointMake(rect.origin.x + (rect.size.width / 2.0), rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight

        let currentContext = UIGraphicsGetCurrentContext()!

        let tipPath = CGPathCreateMutable()
        CGPathMoveToPoint(tipPath, nil, tipLeft, heightWithoutTip)
        CGPathAddLineToPoint(tipPath, nil, tipBottom.x, tipBottom.y)
        CGPathAddLineToPoint(tipPath, nil, tipLeft + tipWidth, heightWithoutTip)
        CGPathCloseSubpath(tipPath)

        fillColor.setFill()
        CGContextAddPath(currentContext, tipPath)
        CGContextFillPath(currentContext)
    }
}
#endif
