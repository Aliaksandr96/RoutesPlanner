import UIKit

protocol RoutesViewProtocol: AnyObject {
    func reloadData()
}

final class RoutesViewController: UITableViewController {
    // MARK: - Public
    
    var presenter: RoutesPresenterProtocol!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupBehavior()
        presenter.getRoutes()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        view.backgroundColor = .backgroundColor()
        title = "Routes"
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
    }
    
    // MARK: - Setup Behavior
    
    private func setupBehavior() {
        tableView.register(RoutesTableCell.self, forCellReuseIdentifier: .identifireRoutesTableCell)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonDidTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonDidTapped))
    }
    
    // MARK: - Helpers
    
    @objc private func editButtonDidTapped() {
        tableView.isEditing.toggle()
        if tableView.isEditing == true {
            navigationItem.rightBarButtonItem?.tintColor = .systemRed
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    @objc private func backButtonDidTapped() {
        presenter.popToRoot()
        presenter.transferRoute(route: presenter.routesArray.last ?? Route())
    }
}

// MARK: - RoutesProtocol

extension RoutesViewController: RoutesViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

extension RoutesViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .identifireRoutesTableCell, for: indexPath) as? RoutesTableCell else { return UITableViewCell() }
        let oneRoute = presenter.routesArray[indexPath.row]
        cell.setupLabels(routeName: oneRoute.nameRoute ?? "",
                         routeDate: oneRoute.dateSaving ?? "")
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.routesArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectRow = presenter.routesArray[indexPath.row]
        presenter.transferRoute(route: selectRow)
        presenter.popToRoot()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteRoute(route: presenter.routesArray[indexPath.row])
            presenter.routesArray.remove(at: indexPath.row)
            presenter.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .backgroundColor()
    }
}
