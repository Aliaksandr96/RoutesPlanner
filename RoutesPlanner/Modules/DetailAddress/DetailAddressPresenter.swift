import Foundation

protocol DetailAddressPresenterProtocol {
    func dissmisView()
    func getLocation()
    func updatePlaceholders()
    func updateCustomerInfo(name: String, flat: String, tel: String)
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
        self.getLocation()
        self.updatePlaceholders()
    }
}

// MARK: - Extension
extension DetailAddressPresenter: DetailAddressPresenterProtocol {
    func updatePlaceholders() {
        view.setupPlaceholders(name: location.nameCustomer, flat: location.flatCustomer, tel: location.telCustomer)
    }
    
    func updateCustomerInfo(name: String, flat: String, tel: String) {
        if !name.isEmpty {
            DatabaseManager.shared.customerName(name: name, location: location)
        }
        if !flat.isEmpty {
            DatabaseManager.shared.customerFlat(flat: flat, location: location)
        }

        if !tel.isEmpty {
            DatabaseManager.shared.customerTel(tel: tel, location: location)
        }
  
    }
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
