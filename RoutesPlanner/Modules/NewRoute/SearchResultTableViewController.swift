import MapKit
import UIKit

final class SearchResultTableViewController: UITableViewController {
    var places: [MKMapItem] = []
    var transferLocation: ((MKMapItem) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .identifireSearchResultTableViewControllerCell)
        tableView.backgroundColor = .backgroundColor()
    }

    public func update(with places: [MKMapItem]) {
        DispatchQueue.main.async { [weak self] in
            self?.places = places
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .identifireSearchResultTableViewControllerCell, for: indexPath)
        cell.backgroundColor = .backgroundColor()
        cell.textLabel?.text = places[indexPath.row].placemark.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transferLocation?(places[indexPath.row])
        tableView.isHidden = true
    }
}
