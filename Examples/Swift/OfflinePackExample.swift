//
//  OfflinePackExample.swift
//  Examples
//
//  Created by Jason Wray on 3/31/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(OfflinePackExample_Swift)

class OfflinePackExample: UIViewController {

    var mapView: MGLMapView!
    var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURL())
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.tintColor = .grayColor()
        view.addSubview(mapView)

        mapView.setCenterCoordinate(CLLocationCoordinate2DMake(22.27933, 114.16281),
                                    zoomLevel: 13, animated: false)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "offlinePackProgressDidChange:", name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "offlinePackDidReceiveError:", name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "offlinePackDidReceiveMaximumAllowedMapboxTiles:", name: MGLOfflinePackProgressChangedNotification, object: nil)

        startOfflinePackDownload()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func startOfflinePackDownload() {
        // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: mapView.zoomLevel, toZoomLevel: mapView.zoomLevel + 2)

        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": "My Offline Pack"]
        let context = NSKeyedArchiver.archivedDataWithRootObject(userInfo)

        // Create and register an offline pack with the shared offline storage object.
        MGLOfflineStorage.sharedOfflineStorage().addPackForRegion(region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedFailureReason)")
                return
            }
            
            // Start downloading.
            pack!.resume()
        }
    }

    // MARK: - MGLOfflinePack notification handlers

    func offlinePackProgressDidChange(notification: NSNotification) {
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String] {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected

            // Calculate current progress percentage.
            let progressPercentage = Float(completedResources) / Float(expectedResources)

            print("Offline pack “\(userInfo["name"])” has downloaded \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")

            // Setup the progress bar.
            if progressView == nil {
                progressView = UIProgressView(progressViewStyle: .Default)
                let frame = view.bounds.size
                progressView.frame = CGRectMake(frame.width / 4, frame.height * 0.75, frame.width / 2, 10)
                view.addSubview(progressView)
            }

            progressView.progress = progressPercentage

            // Is this pack complete?
            if progressPercentage == 100 {
                let byteCount = NSByteCountFormatter.stringFromByteCount(Int64(pack.progress.countOfBytesCompleted), countStyle: NSByteCountFormatterCountStyle.Memory)
                print("Offline pack “\(userInfo["name"])” completed: \(byteCount), \(completedResources) resources")
            }
        }
    }

    func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String],
            error = notification.userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            print("Offline pack “\(userInfo["name"])” received error: \(error.localizedFailureReason)")
        }
    }

    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String],
            maximumCount = notification.userInfo?[MGLOfflinePackMaximumCountUserInfoKey]?.unsignedLongLongValue {
            print("Offline pack “\(userInfo["name"])” reached limit of \(maximumCount) tiles.")
        }
    }

}
