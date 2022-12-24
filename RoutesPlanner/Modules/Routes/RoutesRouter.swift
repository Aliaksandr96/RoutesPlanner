import UIKit

protocol RoutesRouterProtocol {
    func popToRoot()
}

final class RoutesRouter: RoutesRouterProtocol {
    let navigationController: UINavigationController
    let completion: (Route) -> Void

    init(navigationController: UINavigationController, completion: @escaping ((Route) -> Void)) {
        self.navigationController = navigationController
        self.completion = completion
        let view = RoutesViewController()
        let presenter = RoutesPresenter(view: view, router: self)
        view.presenter = presenter
        presenter.transferRoute = { [weak self] route in
            self?.completion(route)
        }
        navigationController.pushViewController(view, animated: true)
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
