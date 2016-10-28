//
//  CustomCalloutView.swift
//  Examples
//
//  Created by Jason Wray on 3/11/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//
#if swift(>=3.0)
import Mapbox

class CustomCalloutView: UIView, MGLCalloutView {
    var representedObject: MGLAnnotation
    
    // Lazy initialization of optional vars for protocols causes segmentation fault: 11s in Swift 3.0. https://bugs.swift.org/browse/SR-1825
    
    var leftAccessoryView = UIView()/* unused */
    var rightAccessoryView = UIView()/* unused */
    
    weak var delegate: MGLCalloutViewDelegate?
    
    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0
    
    let mainBody: UIButton
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        self.mainBody = UIButton(type: .system)
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        mainBody.backgroundColor = backgroundColorForCallout()
        mainBody.tintColor = UIColor.white
        mainBody.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mainBody.layer.cornerRadius = 4.0
        
        addSubview(mainBody)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MGLCalloutView API
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        if !representedObject.responds(to: Selector("title")) {
            return
        }
        
        view.addSubview(self)
        
        // Prepare title label
        mainBody.setTitle(representedObject.title!, for: .normal)
        mainBody.sizeToFit()
        
        if isCalloutTappable() {
            // Handle taps and eventually try to send them to the delegate (usually the map view)
            mainBody.addTarget(self, action: #selector(CustomCalloutView.calloutTapped), for: .touchUpInside)
        } else {
            // Disable tapping and highlighting
            mainBody.isUserInteractionEnabled = false
        }
        
        // Prepare our frame, adding extra space at the bottom for the tip
        let frameWidth = mainBody.bounds.size.width
        let frameHeight = mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        if animated {
            alpha = 0
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
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
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    
    func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
    
    // MARK: - Custom view styling
    
    func backgroundColorForCallout() -> UIColor {
        return UIColor.darkGray
    }
    
    override func draw(_ rect: CGRect) {
        // Draw the pointed tip at the bottom
        let fillColor = backgroundColorForCallout()
        
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        tipPath.closeSubpath()
        
        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
    }
}
#endif
