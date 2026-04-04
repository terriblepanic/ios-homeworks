import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {

    // MARK: - Properties

    private let locationManager = CLLocationManager()
    private var didCenterOnUser = false

    // MARK: - UI

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsCompass = true
        map.showsScale = true
        map.showsTraffic = true
        map.showsBuildings = true
        map.showsUserLocation = true
        map.delegate = self
        return map
    }()

    private lazy var centerOnUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(centerOnUser), for: .touchUpInside)
        return button
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сбросить", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(resetMap), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        view.backgroundColor = .systemBackground
        setupLayout()
        setupLocationManager()
        setupGestureRecognizer()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(mapView)
        view.addSubview(centerOnUserButton)
        view.addSubview(resetButton)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            centerOnUserButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            centerOnUserButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            centerOnUserButton.widthAnchor.constraint(equalToConstant: 44),
            centerOnUserButton.heightAnchor.constraint(equalToConstant: 44),

            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            resetButton.widthAnchor.constraint(equalToConstant: 160),
        ])
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tap)
    }

    // MARK: - Actions

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }

        let coordinate = mapView.convert(
            gesture.location(in: mapView),
            toCoordinateFrom: mapView
        )

        // Показываем выбор действия
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Поставить метку", style: .default) { [weak self] _ in
            self?.addPin(at: coordinate)
        })

        sheet.addAction(UIAlertAction(title: "Построить маршрут", style: .default) { [weak self] _ in
            self?.addPin(at: coordinate)
            self?.buildRoute(to: coordinate)
        })

        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        present(sheet, animated: true)
    }

    @objc private func centerOnUser() {
        guard let coordinate = locationManager.location?.coordinate
                ?? mapView.userLocation.location?.coordinate else {
            showAlert("Местоположение недоступно. Убедитесь, что геолокация разрешена.")
            return
        }
        mapView.setRegion(
            MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000),
            animated: true
        )
    }

    @objc private func resetMap() {
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        mapView.removeOverlays(mapView.overlays)
    }

    // MARK: - Helpers

    private func addPin(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Точка"
        annotation.subtitle = "Новая точка на карте"
        mapView.addAnnotation(annotation)
    }

    // MARK: - Route

    private func buildRoute(to destination: CLLocationCoordinate2D) {
        guard let userCoordinate = locationManager.location?.coordinate
                ?? mapView.userLocation.location?.coordinate else {
            showAlert("Не удалось определить ваше местоположение.")
            return
        }

        mapView.removeOverlays(mapView.overlays)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        MKDirections(request: request).calculate { [weak self] response, error in
            guard let self else { return }

            if let error = error as NSError?, error.code == 4 {
                self.showAlert("Маршрут до этой точки не найден.")
                return
            }

            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 80, left: 20, bottom: 100, right: 20),
                animated: true
            )
        }
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !didCenterOnUser, let location = locations.first else { return }
        didCenterOnUser = true
        mapView.setRegion(
            MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000),
            animated: true
        )
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .locationUnknown { return }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showAlert("Доступ к геолокации запрещён")
        default:
            break
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}
