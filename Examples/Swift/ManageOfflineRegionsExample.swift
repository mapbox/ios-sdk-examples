import Mapbox
import Foundation

@objc(ManageOfflineRegionsExample_Swift)

class ManageOfflineRegionsExample_Swift: UIViewController, MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    lazy var mapView: MGLMapView = {
        let mapView = MGLMapView(frame: CGRect.zero)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .gray
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    lazy var downloadButton: UIButton = {
        let downloadButton = UIButton(frame: CGRect.zero)
        downloadButton.backgroundColor = UIColor.white
        downloadButton.setTitleColor(UIColor.systemBlue, for: .normal)
        downloadButton.setTitle("Download Region", for: .normal)
        downloadButton.addTarget(self, action: #selector(startOfflinePackDownload), for: .touchUpInside)
        downloadButton.layer.cornerRadius = view.bounds.width / 30
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        return downloadButton
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // make an extension for this and make necessary comments and push
    override func viewDidLoad() {

        super.viewDidLoad()

        view.addSubview(mapView)
        view.addSubview(tableView)
        mapView.addSubview(downloadButton)
        let centerCoordinate = CLLocationCoordinate2D(latitude: 22.27933, longitude: 114.16281)
        mapView.setCenter(centerCoordinate, zoomLevel: 13, animated: false)

        // Setup offline pack notification handlers.
        addObserver()
        installConstraints()

    }

    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
    }

    func installConstraints() {

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 0.4),
            downloadButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 100),
            downloadButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 5),
            downloadButton.trailingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 150)
        ])

    }

    /*In a normal app, the cache/ pack removal would be done within
 viewWillDisappear, however, for the purposes of our app, we are calling it
 within viewWillAppear to clear the cache whenever this particular example is
 loaded. */
    override func viewWillAppear(_ animated: Bool) {
        MGLOfflineStorage.shared.resetDatabase { (error) in
            if let error = error {
                // Handle the error here if packs can't be removed.
                print(error)
            } else {
                MGLOfflineStorage.shared.reloadPacks()
            }
        }
    }

    // Create the table view which will display the downloaded regions.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let packs = MGLOfflineStorage.shared.packs {
            return packs.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == 0 {
            label.backgroundColor = UIColor.white
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.text = "No Offline Packs Saved"
            return label
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        
        if let packs = MGLOfflineStorage.shared.packs {
            let pack = packs[indexPath.row]
            
            cell.textLabel?.text = "Region \(indexPath.row + 1): size: \(pack.progress.countOfBytesCompleted)"
            cell.detailTextLabel?.text = "Percent completion: \(pack.progress.percentCompleted)%"

        }

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let packs = MGLOfflineStorage.shared.packs else { return }
        if let selectedRegion = packs[indexPath.row].region as? MGLTilePyramidOfflineRegion {
            mapView.setVisibleCoordinateBounds(selectedRegion.bounds, animated: true)
        }
    }

    @objc func startOfflinePackDownload() {

        /**
         Create a region that includes the current map camera, to be captured
         in an offline map. Note: Because tile count grows exponentially as zoom level
         increases, you should be conservative with your `toZoomLevel` setting.
         */
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: mapView.zoomLevel, toZoomLevel: mapView.zoomLevel + 2)

        // Store some data for identification purposes alongside the offline pack.

        let userInfo = ["name": "\(region.bounds)"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)

        // Create and register an offline pack with the shared offline storage object.

        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            // Start downloading.

            pack!.resume()

        }
    }

    // MARK: - MGLOfflinePack notification handlers

    @objc func offlinePackProgressDidChange(notification: NSNotification) {

        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack,
           let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {

            if pack.progress.countOfResourcesCompleted == pack.progress.countOfResourcesExpected {

                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)

                print("Offline pack “\(userInfo["name"] ?? "unknown")” completed: \(byteCount), \(pack.progress.countOfResourcesCompleted) resources")

            }
        }
        // Reload the table to update the progress percentage for each offline pack.
        self.tableView.reloadData()

    }

}

fileprivate extension MGLOfflinePackProgress {

    var percentCompleted: Float {
        
    return Float((countOfResourcesCompleted / countOfResourcesExpected) * 100)
        
    }
}
