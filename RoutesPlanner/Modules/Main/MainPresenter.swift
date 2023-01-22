import Foundation
import MapKit

protocol MainPresenterProtocol {
    func openNewRouteView()
    func openRoutesView()
    func openDetailViewAndSetLocation(location: Location)
    func viewDidLoaded()
    func checkEmptyArrayAndShowNewRouteButton()
    func addAllAnnotations()
    func addOverlays()
    func localizeCity()
    func navigateToPlace(location: Location)
    func setupAcceptAnnotation(mapView: MKMapView, location: Location, isCompleted: Bool)
    func setupFailedAnnotation(mapView: MKMapView, location: Location, isFailed: Bool)
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
    func openDetailViewAndSetLocation(location: Location) {
        router.openDetailAddressViewAndUpdateTable(setLocationToDetailView: location) { [weak self] _ in
            self?.view.updateLocationsTable()
        }
    }

    func openNewRouteView() {
        router.openNewRouteModule { [weak self] transferLocations in
            self?.locationsArray.removeAll()
            self?.view.removeAllAnatationsAndOverlays()
            self?.locationsArray.append(contentsOf: transferLocations)
            self?.addAllAnnotations()
            self?.addOverlays()
            self?.view.updateLocationsTable()
        }
    }

    func openRoutesView() {
        router.openRoutesView { [weak self] transferRoute in
            self?.locationsArray.removeAll()
            self?.view.updateLocationsTable()
            self?.view.removeAllAnatationsAndOverlays()
            self?.locationsArray.append(contentsOf: transferRoute.location)
            self?.addAllAnnotations()
            self?.addOverlays()
            self?.view.updateLocationsTable()
        }
    }

    func viewDidLoaded() {
        let resultRealmObject = DatabaseManager.shared.getRoute()
        guard let lastLocation = resultRealmObject.last?.location else { return }
        locationsArray.append(contentsOf: lastLocation)
        addAllAnnotations()
        addOverlays()
        view.updateLocationsTable()
    }

    func checkEmptyArrayAndShowNewRouteButton() {
        locationsArray.isEmpty ? view.emptyRouteNewButtonState(state: false) : view.emptyRouteNewButtonState(state: true)
    }

    func addAllAnnotations() {
        locationsArray.forEach {
            view.addAnnotationOnMap(annotation: LocationManager.shared.addAnnotations(location: $0))
        }
    }

    func addOverlays() {
        if !locationsArray.isEmpty {
            for i in 1 ..< locationsArray.count {
                LocationManager.shared.addOverlaysOnMap(mapView: view.mapView,
                                                        latitudeFirstLocation: locationsArray[i-1].latitude,
                                                        longitudeFirstLocation: locationsArray[i-1].longitude,
                                                        latitudeSecondLocation: locationsArray[i].latitude,
                                                        longitudeSecondLocation: locationsArray[i].longitude)
            }
        }
    }

    func localizeCity() {
        view.setRegion(region: LocationManager.shared.localizeCity())
    }

    func navigateToPlace(location: Location) {
        LocationManager.shared.navigationToSelectPlace(location: location)
    }

    func setupAcceptAnnotation(mapView: MKMapView, location: Location, isCompleted: Bool) {
        DatabaseManager.shared.isCompletedPlace(state: isCompleted, location: location)
        LocationManager.shared.setupAcceptAnnotation(mapView: mapView, location: location)
    }

    func setupFailedAnnotation(mapView: MKMapView, location: Location, isFailed: Bool) {
        DatabaseManager.shared.isFailedPlace(state: isFailed, location: location)
        LocationManager.shared.setupFailedAnnotation(mapView: mapView, location: location)
    }
}
