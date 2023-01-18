import UIKit

protocol DetailAddressRouterProtocol {
    func dissmisView()
}

final class DetailAddressRouter: DetailAddressRouterProtocol {
    let navigationController: UINavigationController
    let location: Location
    
    init(navigationController: UINavigationController, location: Location) {
        self.navigationController = navigationController
        self.location = location
        let view = DetailAddressViewController()
        let presenter = DetailAddressPresenter(view: view, router: self, location: location)
        view.presenter = presenter
        navigationController.present(view, animated: true)
    }
    func dissmisView() {
        navigationController.dismiss(animated: true)
    }
}

