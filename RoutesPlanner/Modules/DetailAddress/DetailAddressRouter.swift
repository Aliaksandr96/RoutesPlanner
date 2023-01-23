import UIKit

protocol DetailAddressRouterProtocol {
    func dissmisView()
}

final class DetailAddressRouter: DetailAddressRouterProtocol {
    let navigationController: UINavigationController
    let location: Location
    let completion: (Location) -> Void
    
    init(navigationController: UINavigationController, location: Location, completion: @escaping (Location) -> Void) {
        self.navigationController = navigationController
        self.location = location
        self.completion = completion
        let view = DetailAddressViewController()
        let presenter = DetailAddressPresenter(view: view, router: self, location: location)
        view.presenter = presenter
        presenter.transferCustomerInfo = { [weak self] locations in
            self?.completion(locations)
        }
        navigationController.present(view, animated: true)
    }
    func dissmisView() {
        navigationController.dismiss(animated: true)
    }
}

