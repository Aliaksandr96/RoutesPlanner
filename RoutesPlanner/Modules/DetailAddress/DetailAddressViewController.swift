import UIKit

protocol DetailAddressViewProtocol: AnyObject {
}

final class DetailAddressViewController: UIViewController {
    // MARK: - Public
    var presenter: DetailAddressPresenterProtocol!

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
    }
    private func setupConstraints() { }
    private func configureUI() {
        view.backgroundColor = .red
    }
    private func setupBehavior() { }
}

// MARK: - DetailAddressProtocol
extension DetailAddressViewController: DetailAddressViewProtocol {
}
