import Foundation

protocol DetailAddressPresenterProtocol {
}

final class DetailAddressPresenter {
    // MARK: - Public
    unowned var view: DetailAddressViewProtocol
    
    // MARK: - Private
    private let router: DetailAddressRouterProtocol

    init(view: DetailAddressViewProtocol, router: DetailAddressRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - Extension
extension DetailAddressPresenter: DetailAddressPresenterProtocol {
}
