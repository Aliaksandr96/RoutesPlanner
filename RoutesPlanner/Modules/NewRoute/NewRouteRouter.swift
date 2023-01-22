import UIKit

protocol NewRouteRouterProtocol {
    func popToRoot()
}

final class NewRouteRouter: NewRouteRouterProtocol {
    let navigationController: UINavigationController
    let completion: ([Location]) -> Void

    init(navigationController: UINavigationController, completion: @escaping ([Location]) -> Void) {
        self.navigationController = navigationController
        self.completion = completion
        let view = NewRouteViewController()
        let presenter = NewRoutePresenter(view: view, router: self)
        view.presenter = presenter
        presenter.transferLocationsArray = { [weak self] locations in
            self?.completion(locations)
        }
        navigationController.pushViewController(view, animated: true)
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
