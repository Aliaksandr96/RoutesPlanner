import UIKit
import EasyAutolayout

protocol DetailAddressViewProtocol: AnyObject {
    func updateLabels(buildNumber: String, street: String, postCode: String, subArea: String, city: String)
}

final class DetailAddressViewController: UIViewController {
    // MARK: - Public
    var presenter: DetailAddressPresenterProtocol!
    
    // MARK: - Private
    
    private let addressLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
       return label
    }()
    
    private let subAddresLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 20)
       return label
    }()
    
    private let nameTextField = DetailsTextField()
    private let flatNumberTextField = DetailsTextField()
    private let telTexfField = DetailsTextField()
    
    private let dissmissViewButton: UIButton = {
       let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.blueGold(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
       return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureUI()
        setupBehavior()
    }

    // MARK: - Setups
    private func setupSubviews() {
        [dissmissViewButton, addressLabel, subAddresLabel, nameTextField, flatNumberTextField, telTexfField].forEach { view.addSubview($0)}
    }
    private func setupConstraints() {
        dissmissViewButton.pin
            .top(to: view, offset: 10).trailing(to: view, offset: 10).height(to: 25).width(to: 60)
        addressLabel.pin
            .below(of: dissmissViewButton, offset: 40).leading(to: view, offset: 20).trailing(to: view, offset: 20).height(to: 30)
        subAddresLabel.pin
            .below(of: addressLabel, offset: 20).leading(to: view, offset: 20).trailing(to: view, offset: 20).height(to: 30)
        nameTextField.pin
            .below(of: subAddresLabel, offset: 20).leading(to: view, offset: 20).trailing(to: view, offset: 20).height(to: 55)
        flatNumberTextField.pin
            .below(of: nameTextField, offset: 20).leading(to: view, offset: 20).trailing(to: view, offset: 20).height(to: 55)
        telTexfField.pin
            .below(of: flatNumberTextField, offset: 20).leading(to: view, offset: 20).trailing(to: view, offset: 20).height(to: 55)
        
    }
    private func configureUI() {
        view.backgroundColor = .backgroundColor()
        nameTextField.setTitle("Name:")
        flatNumberTextField.setTitle("Flat Number:")
        telTexfField.setTitle("Tel:")
    }
    private func setupBehavior() {
        dissmissViewButton.addTarget(self, action: #selector(dissmissViewButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    @objc private func dissmissViewButtonDidTapped() {
        presenter.dissmisView()
    }
}

// MARK: - DetailAddressProtocol
extension DetailAddressViewController: DetailAddressViewProtocol {
    func updateLabels(buildNumber: String, street: String, postCode: String, subArea: String, city: String) {
        addressLabel.text = "\(street), \(buildNumber)"
        subAddresLabel.text = "\(city), \(postCode), \(subArea)"
    }
}
