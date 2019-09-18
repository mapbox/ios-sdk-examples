import Mapbox

// Ornament positions matrix array, this example will demonstrate how ornament looks like in different positions.
let ornamentPosition: [[MGLOrnamentPosition]] = [
    [.topLeft, .topRight, .bottomRight, .bottomLeft],
    [.topRight, .bottomRight, .bottomLeft, .topLeft],
    [.bottomRight, .bottomLeft, .topLeft, .topRight],
    [.bottomLeft, .topLeft, .topRight, .bottomRight]
]

@objc(OrnamentsLayoutExample_Swift)
class OrnamentsLayoutExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var timer: Timer?
    var currentPositionIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsScale = true
        mapView.setCenter(CLLocationCoordinate2DMake(39.915143, 116.404053), zoomLevel: 16, direction: 30, animated: false)
        self.view.addSubview(mapView)

        mapView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Create a timer to update ornaments position every second.
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerTick), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let timer = self.timer else {
            return
        }
        // Stop the timer if the view was removed.
        timer.invalidate()
        self.timer = nil
    }

    func updateOrnamentsPosition() {
        // Get position matrix for current turn. We mod 4 to roll over the matrix array.
        let positions = ornamentPosition[self.currentPositionIndex%4]
        // Update ornaments position with position matrix.
        self.mapView.scaleBarPosition = positions[0]
        self.mapView.compassViewPosition = positions[1]
        self.mapView.logoViewPosition = positions[2]
        self.mapView.attributionButtonPosition = positions[3]
    }

    @objc func onTimerTick() {
        self.currentPositionIndex += 1
        self.updateOrnamentsPosition()
    }
}
