import EasyAutolayout
import MapKit
import UIKit

protocol MainViewProtocol: AnyObject {
    func updateLocationsTable()
    func addAnnotationOnMap(annotation: MKAnnotation)
    func setRegion(region: MKCoordinateRegion)
    func removeAllAnatationsAndOverlays()
    func emptyRouteNewButtonState(state: Bool)
    var mapView: MKMapView { get }
}

final class MainViewController: UIViewController {
    // MARK: - Public

    var presenter: MainPresenterProtocol!

    // MARK: - Private

    var mapView = MKMapView()

    private let backgroundTableView = UIView()
    private let locationsTableView = UITableView()
    private let localizeCityButton = UIButton()
    private let emptyRoutesNewButton = UIButton()

    private enum Constants {
        static let clearOpacity: Float = 0.25
        static let normalOpacity: Float = 1
        static let cornerRadius: CGFloat = 15
        static let locilizeCityButtonSize: CGFloat = 30
        static let borderWidthSize: CGFloat = 1
        static let tableRowHeightSize: CGFloat = 120
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureUI()
        setupBehavior()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.localizeCity()
        presenter.checkEmptyArrayAndShowNewRouteButton()
    }

    // MARK: - Setup Subviews

    private func setupSubviews() {
        [mapView, backgroundTableView, localizeCityButton, emptyRoutesNewButton].forEach { view.addSubview($0) }
        backgroundTableView.addSubview(locationsTableView)
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        mapView.pin
            .top(to: view.safeAreaLayoutGuide).width(to: view).height(to: view, multiplier: 1 / 1.8)
        backgroundTableView.pin
            .below(of: mapView, offset: -40).bottom(to: view, offset: -1).leading(to: view, offset: 1).trailing(to: view, offset: 1)
        locationsTableView.pin
            .top(to: backgroundTableView, offset: 15).bottom(to: view, offset: 2).leading(to: view, offset: 2).trailing(to: view, offset: 2)
        localizeCityButton.pin
            .above(of: backgroundTableView, offset: 10).leading(to: mapView, offset: 10).width(to: 30).height(to: 30)
        emptyRoutesNewButton.pin
            .center(in: backgroundTableView).width(to: 200).height(to: 50)
    }

    // MARK: - Configure UI

    private func configureUI() {
        view.backgroundColor = .backgroundColor()
        backgroundTableView.layer.cornerRadius = Constants.cornerRadius
        backgroundTableView.layer.borderColor = UIColor.systemBlue.cgColor
        backgroundTableView.layer.borderWidth = Constants.borderWidthSize
        [locationsTableView, backgroundTableView].forEach { $0.backgroundColor = .backgroundColor() }
        backgroundTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        locationsTableView.rowHeight = Constants.tableRowHeightSize
        locationsTableView.separatorStyle = .none

        let configuration = UIImage.SymbolConfiguration(pointSize: Constants.locilizeCityButtonSize, weight: .bold)
        localizeCityButton.setImage(UIImage(systemName: "location.circle.fill", withConfiguration: configuration), for: .normal)

        emptyRoutesNewButton.setTitle("New Route", for: .normal)
        emptyRoutesNewButton.backgroundColor = .pinBlue()
        emptyRoutesNewButton.setTitleColor(.white, for: .normal)
        emptyRoutesNewButton.layer.cornerRadius = Constants.cornerRadius
    }

    // MARK: - Setup Behavior

    private func setupBehavior() {
        mapView.showsUserLocation = true
        locationsTableView.register(LocationsTableViewCell.self, forCellReuseIdentifier: .identifireLocationsTableViewCell)
        locationsTableView.dataSource = self
        locationsTableView.delegate = self
        mapView.delegate = self

        localizeCityButton.addTarget(self, action: #selector(localizeCityButtonDidTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Route", style: .plain, target: self, action: #selector(newButtonDidTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Routes", style: .plain, target: self, action: #selector(routesButtonDidTapped))
        emptyRoutesNewButton.addTarget(self, action: #selector(emptyRoutesNewButtonDidTapped), for: .touchUpInside)
    }

    // MARK: - Helpers

    @objc private func emptyRoutesNewButtonDidTapped() {
        presenter.openNewRouteView()
    }

    @objc private func newButtonDidTapped() {
        presenter.openNewRouteView()
    }

    @objc private func routesButtonDidTapped() {
        presenter.openRoutesView()
    }

    @objc private func localizeCityButtonDidTapped() {
        presenter.localizeCity()
    }
}

// MARK: - MainProtocol

extension MainViewController: MainViewProtocol {
    func emptyRouteNewButtonState(state: Bool) {
        emptyRoutesNewButton.isHidden = state
    }

    func updateLocationsTable() {
        locationsTableView.reloadData()
    }

    func addAnnotationOnMap(annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }

    func addOverlaysOnMap(overlays: [MKOverlay]) {
        mapView.addOverlays(overlays)
    }

    func removeAllAnatationsAndOverlays() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }

    func setRegion(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - Locations Table View Data Source

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.locationsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .identifireLocationsTableViewCell, for: indexPath) as? LocationsTableViewCell else { return UITableViewCell() }
        let location = presenter.locationsArray[indexPath.row]
        let countRow = presenter.locationsArray.indices[indexPath.row] + 1
        cell.setupLabels(numberBuilding: location.building,
                         street: location.street,
                         postCode: location.postCode,
                         subArea: location.subAdminArea,
                         city: location.city,
                         countRow: countRow)

        if presenter.locationsArray[indexPath.row].isComplited == true {
            cell.deliveryLabelState(state: true)
        }
        if presenter.locationsArray[indexPath.row].isFailed == true {
            cell.deliveryLabelState(state: false)
        }

        cell.textInDescriptionView(apartmentNumber: location.flatCustomer,
                                   clientName: location.nameCustomer,
                                   tel: location.telCustomer)

        if presenter.locationsArray[indexPath.row].isComplited == true || presenter.locationsArray[indexPath.row].isFailed == true {
            cell.changesHideButton(acceptButtonHide: true, failedButtonHide: true, navigateButtonHide: true, undoButtonHide: false, deliveryLabel: false)
            cell.labelsOpacity(value: Constants.clearOpacity)
        } else {
            cell.changesHideButton(acceptButtonHide: false, failedButtonHide: false, navigateButtonHide: false, undoButtonHide: true, deliveryLabel: true)
            cell.labelsOpacity(value: Constants.normalOpacity)
        }

        cell.acceptClosure = { [weak self] in
            guard let self = self else { return }
            cell.changesHideButton(acceptButtonHide: true, failedButtonHide: true, navigateButtonHide: true, undoButtonHide: false, deliveryLabel: false)
            cell.labelsOpacity(value: Constants.clearOpacity)
            cell.deliveryLabelState(state: true)
            self.presenter.setupAcceptAnnotation(mapView: self.mapView, location: location, isCompleted: true)
        }

        cell.failedClosure = { [weak self] in
            guard let self = self else { return }
            cell.changesHideButton(acceptButtonHide: true, failedButtonHide: true, navigateButtonHide: true, undoButtonHide: false, deliveryLabel: false)
            cell.labelsOpacity(value: Constants.clearOpacity)
            cell.deliveryLabelState(state: false)
            self.presenter.setupFailedAnnotation(mapView: self.mapView, location: location, isFailed: true)
        }

        cell.navigateClosure = { [weak self] in
            self?.presenter.navigateToPlace(location: location)
        }

        cell.undoClosure = { [weak self] in
            guard let self = self else { return }
            cell.changesHideButton(acceptButtonHide: false, failedButtonHide: false, navigateButtonHide: false, undoButtonHide: true, deliveryLabel: true)
            cell.labelsOpacity(value: Constants.normalOpacity)
            self.presenter.setupAcceptAnnotation(mapView: self.mapView, location: location, isCompleted: false)
            self.presenter.setupFailedAnnotation(mapView: self.mapView, location: location, isFailed: false)
        }
        return cell
    }
}

// MARK: - UI Table View Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.openDetailViewAndSetLocation(location: presenter.locationsArray[indexPath.row])
    }
}

extension MainViewController: MKMapViewDelegate {
    // MARK: - Annotation View Appearance

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")

        if annotation.subtitle == Subtitles.completed.rawValue {
            annotationView.markerTintColor = .pinGreen()
            annotationView.glyphImage = UIImage(systemName: "checkmark.circle")
            annotationView.glyphTintColor = .white
        } else if annotation.subtitle == Subtitles.failed.rawValue {
            annotationView.markerTintColor = .pinRed()
            annotationView.glyphImage = UIImage(systemName: "xmark.circle")
            annotationView.glyphTintColor = .white
        } else {
            annotationView.markerTintColor = .pinBlue()
            annotationView.glyphTintColor = .white
            annotationView.glyphImage = UIImage(systemName: "shippingbox")
        }
        return annotationView
    }

    // MARK: - Overlay Apperance

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .pinBlue()
        renderer.lineWidth = 5.0
        return renderer
    }
}
