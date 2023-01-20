import Foundation
import MapKit

protocol MainPresenterProtocol {
    func openNewRouteView()
    func openRoutesView()
    func openDetailView(location: Location)
    func viewDidLoaded()
    func checkEmptyArray()
    func addAllAnnotations()
    func localizeCity()
    func localizePlace(location: Location)
    func navigateToPlace(location: Location)
    func isCompletedPlace(state: Bool, location: Location)
    func isFailedPlace(state: Bool, location: Location)
    func setupAcceptAnnotation(mapView: MKMapView, location: Location)
    func setupFailedAnnotation(mapView: MKMapView, location: Location)
    var locationsArray: [Location] { get set }
}

final class MainPresenter {
    // MARK: - Public

    unowned var view: MainViewProtocol

    // MARK: - Private

    private let router: MainRouterProtocol

    // MARK: - Variables

    var locationsArray: [Location] = []

    init(view: MainViewProtocol, router: MainRouterProtocol) {
        self.view = view
        self.router = router
        viewDidLoaded()
    }
}

// MARK: - Extension Main Presenter

extension MainPresenter: MainPresenterProtocol {
    func openDetailView(location: Location) {
        router.openDetailAddressView(location: location)
    }

    func openNewRouteView() {
        router.openNewRouteModule { [weak self] transferLocations in
            self?.locationsArray.removeAll()
            self?.view.removeAllAnatations()
            self?.locationsArray.append(contentsOf: transferLocations)
            self?.addAllAnnotations()
            self?.view.updateLocationsTable()
        }
    }

    func openRoutesView() {
        router.openRoutesView { [weak self] transferRoute in
            self?.locationsArray.removeAll()
            self?.view.updateLocationsTable()
            self?.view.removeAllAnatations()
            self?.locationsArray.append(contentsOf: transferRoute.location)
            self?.addAllAnnotations()
            self?.view.updateLocationsTable()
        }
    }

    func viewDidLoaded() {
        let resultRealmObject = DatabaseManager.shared.getRoute()
        guard let lastLocation = resultRealmObject.last?.location else { return }
        locationsArray.append(contentsOf: lastLocation)
        addAllAnnotations()
        view.updateLocationsTable()
    }

    func checkEmptyArray() {
        if locationsArray.isEmpty == true {
            view.emptyRouteNewButtonState(state: false)
        } else {
            view.emptyRouteNewButtonState(state: true)
        }
    }

    func addAllAnnotations() {
        view.removeAllAnatations()
        locationsArray.forEach {
            let points = LocationManager.shared.addAnnotations(location: $0)
            view.addAnnotationOnMap(annotation: points)
        }
    }

    func localizeCity() {
        view.setRegion(region: LocationManager.shared.localizeCity())
    }

    func navigateToPlace(location: Location) {
        LocationManager.shared.navigationToSelectPlace(location: location)
    }

    func isCompletedPlace(state: Bool, location: Location) {
        DatabaseManager.shared.isCompletedPlace(state: state, location: location)
    }

    func isFailedPlace(state: Bool, location: Location) {
        DatabaseManager.shared.isFailedPlace(state: state, location: location)
    }

    func localizePlace(location: Location) {
        view.setRegion(region: LocationManager.shared.localizePlace(location: location))
    }

    func setupAcceptAnnotation(mapView: MKMapView, location: Location) {
        LocationManager.shared.setupAcceptAnnotation(mapView: mapView, location: location)
    }

    func setupFailedAnnotation(mapView: MKMapView, location: Location) {
        LocationManager.shared.setupFailedAnnotation(mapView: mapView, location: location)
    }
}
