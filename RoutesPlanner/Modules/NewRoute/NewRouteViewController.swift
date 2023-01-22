import EasyAutolayout
import MapKit
import UIKit

protocol NewRouteViewProtocol: AnyObject {
    func updateNewRouteTableView()
    func showEmptyLocationsArrayAlert()
}

final class NewRouteViewController: UIViewController {
    // MARK: - Public

    var presenter: NewRoutePresenterProtocol!

    // MARK: - Private

    private let searchView = UISearchController(searchResultsController: SearchResultTableViewController())
    private let newRouteTableView = UITableView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureUI()
        setupBehavior()
    }

    // MARK: - Setup Subviews

    private func setupSubviews() {
        [newRouteTableView].forEach { view.addSubview($0) }
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        newRouteTableView.pin
            .top(to: view.safeAreaLayoutGuide).width(to: view).bottom(to: view)
    }

    // MARK: - Configure UI

    private func configureUI() {
        view.backgroundColor = .backgroundColor()
        navigationItem.searchController = searchView
        searchView.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        newRouteTableView.rowHeight = 60
        newRouteTableView.separatorStyle = .none
        newRouteTableView.backgroundColor = .backgroundColor()
    }

    // MARK: - Setup Behavior

    private func setupBehavior() {
        searchView.searchResultsUpdater = self
        newRouteTableView.dataSource = self
        newRouteTableView.delegate = self
        newRouteTableView.register(NewRouteTableViewCell.self, forCellReuseIdentifier: .identifireNewRouteCell)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonDidTapped)),
            UIBarButtonItem(title: "Save Route", style: .done, target: self, action: #selector(saveRouteButtonDidTapped))
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonDidTapped))
    }

    // MARK: - Helpers

    @objc private func editButtonDidTapped() {
        newRouteTableView.isEditing.toggle()
        if newRouteTableView.isEditing == true {
            navigationItem.rightBarButtonItem?.tintColor = .systemRed
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }

    @objc private func backButtonDidTapped() {
        presenter.popToRoot()
    }

    @objc private func saveRouteButtonDidTapped() {
        presenter.checkRouteAndSave()
    }
}

// MARK: - NewRouteProtocol

extension NewRouteViewController: NewRouteViewProtocol {
    func showEmptyLocationsArrayAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please, add at least one route", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .destructive)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func updateNewRouteTableView() {
        newRouteTableView.reloadData()
    }
}

// MARK: - Table View Protocols

extension NewRouteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.locationsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .identifireNewRouteCell, for: indexPath) as? NewRouteTableViewCell else { return UITableViewCell() }
        let place = presenter.locationsArray[indexPath.row]
        let countRow = presenter.locationsArray.indices[indexPath.row] + 1
        cell.setupLabels(street: place.street,
                         buildingNumber: place.building,
                         postCode: place.postCode,
                         city: place.city,
                         subArea: place.subAdminArea,
                         countRow: countRow)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.locationsArray.remove(at: indexPath.row)
        presenter.updateTable()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .backgroundColor()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UI Search Results Updating

extension NewRouteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchView.searchBar.text, let resultViewController = searchView.searchResultsController as? SearchResultTableViewController else { return }
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let response = response else { return }
            let location = Location()
            DispatchQueue.main.async {
                resultViewController.update(with: response.mapItems)
                resultViewController.transferLocation = { [weak self] item in
                    location.city = item.placemark.locality ?? ""
                    location.street = item.placemark.thoroughfare ?? ""
                    location.building = item.placemark.subThoroughfare ?? ""
                    location.postCode = item.placemark.postalCode ?? ""
                    location.longitude = item.placemark.location?.coordinate.longitude ?? 0
                    location.latitude = item.placemark.location?.coordinate.latitude ?? 0
                    location.subAdminArea = item.placemark.subLocality ?? ""
                    self?.presenter.locationsArray.append(location)
                    self?.presenter.updateTable()
                    self?.searchView.searchBar.text = ""
                }
            }
        }
    }
}
