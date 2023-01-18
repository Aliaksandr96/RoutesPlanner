import UIKit

protocol DetailAddressRouterProtocol {
}

final class DetailAddressRouter: DetailAddressRouterProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let view = DetailAddressViewController()
        let presenter = DetailAddressPresenter(view: view, router: self)
        view.presenter = presenter
        navigationController.present(view, animated: true)
    }
}

