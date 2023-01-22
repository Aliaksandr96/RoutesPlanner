import Foundation

protocol DetailAddressPresenterProtocol {
    func dissmisView()
    func updateLabelsFromGettingLocation()
    func updatePlaceholders()
    func updateCustomerInfo(name: String, flat: String, tel: String)
    func saveInfoCustomerFromTextFields()
}

final class DetailAddressPresenter {
    // MARK: - Public

    unowned var view: DetailAddressViewProtocol

    // MARK: - Private

    private let router: DetailAddressRouterProtocol
    private let location: Location

    // MARK: - Variables

    var transferCustomerInfo: ((Location) -> Void)?

    init(view: DetailAddressViewProtocol, router: DetailAddressRouterProtocol, location: Location) {
        self.view = view
        self.router = router
        self.location = location
        updateLabelsFromGettingLocation()
        updatePlaceholders()
    }
}

// MARK: - Extension

extension DetailAddressPresenter: DetailAddressPresenterProtocol {
    func saveInfoCustomerFromTextFields() {
        transferCustomerInfo?(location)
    }

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

    func updateLabelsFromGettingLocation() {
        view.updateLabels(buildNumber: location.building,
                          street: location.street,
                          postCode: location.postCode,
                          subArea: location.subAdminArea,
                          city: location.city)
    }
}
