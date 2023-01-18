import UIKit

protocol MainRouterProtocol {
    func openNewRouteModule(completion: @escaping (([Location]) -> Void))
    func openRoutesView(completion: @escaping ((Route) -> Void))
    func openDetailAddressView()
}

final class MainRouter: MainRouterProtocol {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let view = MainViewController()
        let presenter = MainPresenter(view: view, router: self)
        view.presenter = presenter
        navigationController.pushViewController(view, animated: true)
    }

    func openNewRouteModule(completion: @escaping (([Location]) -> Void)) {
        _ = NewRouteRouter(navigationController: navigationController, completion: completion)
    }

    func openRoutesView(completion: @escaping ((Route) -> Void)) {
        _ = RoutesRouter(navigationController: navigationController, completion: completion)
    }
    func openDetailAddressView() {
        _ = DetailAddressRouter(navigationController: navigationController)
    }
}
