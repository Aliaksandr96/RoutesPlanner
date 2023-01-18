import Foundation
import MapKit

protocol NewRoutePresenterProtocol {
    var locationsArray: [Location] { get set }
    func updateTable()
    func saveRouteToDatabase()
    func checkRouteAndSave()
    func popToRoot()
    func openDetailView(location: Location)
    func transferCurrentLocationsArrayToMainTable(locations: [Location])
}

final class NewRoutePresenter {
    // MARK: - Public

    unowned var view: NewRouteViewProtocol

    // MARK: - Private

    private let router: NewRouteRouterProtocol

    // MARK: - Variables

    var locationsArray: [Location] = []
    var transferLocationsArray: (([Location]) -> Void)?

    init(view: NewRouteViewProtocol, router: NewRouteRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - Extension

extension NewRoutePresenter: NewRoutePresenterProtocol {
    func checkRouteAndSave() {
        if locationsArray.isEmpty == true {
            view.showEmptyLocationsArrayAlert()
        } else {
            saveRouteToDatabase()
            transferCurrentLocationsArrayToMainTable(locations: locationsArray)
            popToRoot()
        }
    }

    func updateTable() {
        view.updateNewRouteTableView()
    }

    func saveRouteToDatabase() {
        let route = Route()
        route.dateSaving = Date.formating(date: Date())
        route.nameRoute = Date.routeDay()
        route.location.append(objectsIn: locationsArray)
        DatabaseManager.shared.saveRoute(route: route)
    }

    func openDetailView(location: Location) {
        router.openDetailView(location: location)
    }
    
    func popToRoot() {
        router.popToRoot()
    }

    func transferCurrentLocationsArrayToMainTable(locations: [Location]) {
        transferLocationsArray?(locationsArray)
    }
}
