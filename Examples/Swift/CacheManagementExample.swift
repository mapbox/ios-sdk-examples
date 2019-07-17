import Mapbox

@objc(CacheManagementExample_Swift)

class CacheManagementExample_Swift: UIViewController, MGLMapViewDelegate, UIActionSheetDelegate {

    var mapView: MGLMapView!
    var alertController: UIAlertController!
    var alertButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL)
        mapView.delegate = self
        view.addSubview(mapView)

        addOfflinePack()
        addButton()
    }

    func addOfflinePack() {
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: 0, toZoomLevel: 2)

        let info = ["name": "Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: info)
        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            pack?.resume()
        }
    }

    // MARK: Cache management methods called by action sheet
    func invalidateAmbientCache() {
        MGLOfflineStorage.shared.invalidateAmbientCache { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
        }
    }
    
    func invalidateOfflinePack() {

        if let pack = MGLOfflineStorage.shared.packs?.first {
            MGLOfflineStorage.shared.invalidatePack(pack) { (error) in
                guard error == nil else {
                    // The pack couldn’t be invalidated for some reason.
                    print("Error: \(error?.localizedDescription ?? "unknown error")")
                    return
                }
                print("\(pack.context) has been invalidated")
            }
        }
    }

    func clearAmbientCache() {
        MGLOfflineStorage.shared.clearAmbientCache { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
        }
    }

    func resetDatabase() {
        MGLOfflineStorage.shared.resetDatabase { (error) in
            print("Error: \(error?.localizedDescription ?? "unknown error")")
            return
        }
    }

    //MARK: Add UI components
    func addButton() {
        alertButton = UIButton(type: .infoDark)
        alertButton.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        alertButton.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(alertButton, aboveSubview: mapView)

        // TODO: Fix unsatisfiable constraints
        NSLayoutConstraint.activate([NSLayoutConstraint(item: alertButton!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mapView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: -20)])
        NSLayoutConstraint.activate([NSLayoutConstraint(item: alertButton, attribute: .bottom, relatedBy: .equal, toItem: mapView.attributionButton, attribute: .top, multiplier: 1, constant: -20)])
        alertButton.addTarget(self, action:
            #selector(presentActionSheet), for: .touchUpInside)
    }

    // Create an action sheet that handles the cache management.
    @objc func presentActionSheet() {
        if (alertController == nil) {
            alertController = UIAlertController(title: "Cache Management Options", message: nil, preferredStyle: .actionSheet)

            let actions = ["Invalidate Ambient Cache", "Invalidate Offline Pack", "Clear Ambient Cache", "Reset Database"]
            for action in actions {
                alertController.addAction(UIAlertAction(title: action, style: .default, handler: nil))
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        alertController.popoverPresentationController?
            .sourceRect = alertButton.bounds
        present(alertController, animated: true, completion: nil)
    }

    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            invalidateAmbientCache()
        case 1:
            invalidateOfflinePack()
        case 2:
            clearAmbientCache()
        case 3:
            resetDatabase()
        default:
            break
        }
    }
    // JK Not working
    //    func getCacheDatabaseSize() -> Int {
    //        if var cacheURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
    //            if let bundleIdentifier = Bundle.main.bundleIdentifier {
    //                cacheURL.appendPathComponent(bundleIdentifier)
    //            } else {
    //                let bundleIdentifier = Bundle(for: MGLAccountManager.self).bundleIdentifier!
    //                cacheURL.appendPathComponent(bundleIdentifier)
    //            }
    //            cacheURL.appendPathComponent( ".mapbox/cache.db")
    //            let attributes = FileManager.default.attributesOfItem(atPath: cacheURL.relativeString)
    //            if let size = attributes[FileAttributeKey.size] {
    //                return size
    //            }
    //        }
    //        return 0
    //    }
}
