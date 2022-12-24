import EasyAutolayout
import MapKit
import UIKit

protocol MainViewProtocol: AnyObject {
    func updateLocationsTable()
    func addAnnotationOnMap(annotation: MKAnnotation)
    func setRegion(region: MKCoordinateRegion)
    func removeAllAnatations()
}

enum OpacityValue: Float {
    case clear = 0.25
    case normal = 1
}

final class MainViewController: UIViewController {
    // MARK: - Public

    var presenter: MainPresenterProtocol!

    // MARK: - Private

    private let mapView = MKMapView()
    private let backgroundTableView = UIView()
    private let locationsTableView = UITableView()
    private let localizeCityButton = UIButton()

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
    }

    // MARK: - Setup Subviews

    private func setupSubviews() {
        [mapView, backgroundTableView, locationsTableView, localizeCityButton].forEach { view.addSubview($0) }
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        mapView.pin
            .top(to: view.safeAreaLayoutGuide).width(to: view).height(to: view, multiplier: 1 / 1.8)
        backgroundTableView.pin
            .below(of: mapView, offset: -40).width(to: view).bottom(to: view)
        locationsTableView.pin
            .top(to: backgroundTableView, offset: 15).width(to: backgroundTableView).bottom(to: view)
        localizeCityButton.pin
            .above(of: backgroundTableView, offset: 10).leading(to: mapView, offset: 10).width(to: 30).height(to: 30)
    }

    // MARK: - Configure UI

    private func configureUI() {
        view.backgroundColor = .backgroundColor()
        backgroundTableView.layer.cornerRadius = 20 
        [locationsTableView, backgroundTableView].forEach { $0.backgroundColor = .backgroundColor() }
        backgroundTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        locationsTableView.rowHeight = 100
        locationsTableView.separatorStyle = .none
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        localizeCityButton.setImage(UIImage(systemName: "location.circle.fill", withConfiguration: configuration), for: .normal)
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
    }

    // MARK: - Helpers

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
    func updateLocationsTable() {
        locationsTableView.reloadData()
    }

    func addAnnotationOnMap(annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }

    func removeAllAnatations() {
        mapView.removeAnnotations(mapView.annotations)
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
        cell.setupLabels(numberBuilding: location.building,
                         street: location.street,
                         postCode: location.postCode,
                         subArea: location.subAdminArea,
                         city: location.city)

        if presenter.locationsArray[indexPath.row].isComplited == true || presenter.locationsArray[indexPath.row].isFailed == true {
            cell.changesHideButton(acceptButtonHide: true, failedButtonHide: true, navigateButtonHide: true, undoButtonHide: false)
            cell.labelsOpacity(value: OpacityValue.clear.rawValue)
        } else {
            cell.changesHideButton(acceptButtonHide: false, failedButtonHide: false, navigateButtonHide: false, undoButtonHide: true)
            cell.labelsOpacity(value: OpacityValue.normal.rawValue)
        }

        cell.acceptClosure = { [weak self] in
            guard let self = self else { return }
            cell.changesHideButton(acceptButtonHide: true, failedButtonHide: true, navigateButtonHide: true, undoButtonHide: false)
            cell.labelsOpacity(value: OpacityValue.clear.rawValue)
            self.presenter.isCompletedPlace(state: true, location: location)
            self.presenter.setupAcceptAnnotation(mapView: self.mapView, location: location)
        }

        cell.failedClosure = { [weak self] in
            guard let self = self else { return }
            cell.changesHideButton(acceptButtonHide: true, failedButtonHide: true, navigateButtonHide: true, undoButtonHide: false)
            cell.labelsOpacity(value: OpacityValue.clear.rawValue)
            self.presenter.isFailedPlace(state: true, location: location)
            self.presenter.setupFailedAnnotation(mapView: self.mapView, location: location)
        }

        cell.navigateClosure = { [weak self] in
            self?.presenter.navigateToPlace(location: location)
        }

        cell.undoClosure = { [weak self] in
            guard let self = self else { return }
            cell.changesHideButton(acceptButtonHide: false, failedButtonHide: false, navigateButtonHide: false, undoButtonHide: true)
            cell.labelsOpacity(value: OpacityValue.normal.rawValue)
            self.presenter.isCompletedPlace(state: false, location: location)
            self.presenter.isFailedPlace(state: false, location: location)
            self.presenter.setupAcceptAnnotation(mapView: self.mapView, location: location)
            self.presenter.setupFailedAnnotation(mapView: self.mapView, location: location)
        }
        return cell
    }
}

// MARK: - UI Table View Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = presenter.locationsArray[indexPath.row]
        presenter.localizePlace(location: location)
    }
}

extension MainViewController: MKMapViewDelegate {
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
}
