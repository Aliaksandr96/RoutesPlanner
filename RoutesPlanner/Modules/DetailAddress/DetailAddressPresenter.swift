import Foundation

protocol DetailAddressPresenterProtocol {
    func dissmisView()
    func getLocation()
}

final class DetailAddressPresenter {
    // MARK: - Public
    unowned var view: DetailAddressViewProtocol
    
    // MARK: - Private
    private let router: DetailAddressRouterProtocol
    private let location: Location

    init(view: DetailAddressViewProtocol, router: DetailAddressRouterProtocol, location: Location) {
        self.view = view
        self.router = router
        self.location = location
        getLocation()
    }
}

// MARK: - Extension
extension DetailAddressPresenter: DetailAddressPresenterProtocol {
    func dissmisView() {
        router.dissmisView()
    }
    func getLocation() {
        view.updateLabels(buildNumber: location.building,
                          street: location.street,
                          postCode: location.postCode,
                          subArea: location.subAdminArea,
                          city: location.city)
    }
}
