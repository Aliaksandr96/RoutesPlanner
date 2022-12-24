import Foundation

protocol RoutesPresenterProtocol {
    var routesArray: [Route] { get set }
    func getRoutes()
    func popToRoot()
    func reloadData()
    func transferRoute(route: Route)
    func deleteRoute(route: Route)
}

final class RoutesPresenter {
    // MARK: - Public

    unowned var view: RoutesViewProtocol

    // MARK: - Private

    private let router: RoutesRouterProtocol

    // MARK: - Variables

    var routesArray: [Route] = []
    var transferRoute: ((Route) -> Void)?

    init(view: RoutesViewProtocol, router: RoutesRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - Extension

extension RoutesPresenter: RoutesPresenterProtocol {
    func getRoutes() {
        routesArray.append(contentsOf: DatabaseManager.shared.getRoute())
        view.reloadData()
    }

    func popToRoot() {
        router.popToRoot()
    }

    func transferRoute(route: Route) {
        transferRoute?(route)
    }

    func deleteRoute(route: Route) {
        DatabaseManager.shared.deleteRoute(route: route)
    }

    func reloadData() {
        view.reloadData()
    }
}
