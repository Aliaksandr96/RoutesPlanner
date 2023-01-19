import EasyAutolayout
import UIKit

final class LocationsTableViewCell: UITableViewCell {
    // MARK: - Private
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let adressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackGold()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    private let subAdressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayWhite()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let countRowLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .blueGold()
        return label
    }()
    
    private let descriptionView = DescriptionView()
    
    // MARK: - Public
    
    let acceptButton = UIButton()
    let navigateButton = UIButton()
    let failedButton = UIButton()
    let undoButton = UIButton()
    
    // MARK: - Variables
    
    var acceptClosure: (() -> Void)?
    var navigateClosure: (() -> Void)?
    var failedClosure: (() -> Void)?
    var undoClosure: (() -> Void)?
    
    // MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: .identifireLocationsTableViewCell)

        setupSubviews()
        setupConstraints()
        configureUI()
        setupBechavior()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Subviews

    func setupSubviews() {
        [cellView, countRowLabel, adressLabel, descriptionView, subAdressLabel, acceptButton, navigateButton, failedButton, undoButton].forEach { contentView.addSubview($0) }
    }

    // MARK: - Setup Constraints

    func setupConstraints() {
        cellView.pin
            .top(to: contentView, offset: 5).leading(to: contentView, offset: 10).trailing(to: contentView, offset: 10).bottom(to: contentView)
        adressLabel.pin
            .top(to: cellView, offset: 4).leading(to: cellView, offset: 10).trailing(to: cellView, offset: 26).height(to: 20)
        countRowLabel.pin
            .top(to: cellView, offset: 4).trailing(to: cellView, offset: 5).height(to: 20).width(to: 20)
        subAdressLabel.pin
            .below(of: adressLabel, offset: 1).leading(to: adressLabel).before(of: acceptButton, offset: 1).height(to: 20)
        descriptionView.pin
            .below(of: subAdressLabel, offset: 4).leading(to: adressLabel).bottom(to: cellView, offset: 5).before(of: acceptButton, offset: 5)
        navigateButton.pin
            .bottom(to: cellView, offset: 4).trailing(to: cellView, offset: 8).width(to: 35).height(to: 35)
        failedButton.pin
            .before(of: navigateButton, offset: 8).bottom(to: navigateButton).width(to: 35).height(to: 35)
        acceptButton.pin
            .before(of: failedButton, offset: 8).bottom(to: navigateButton).width(to: 35).height(to: 35)
        undoButton.pin
            .before(of: navigateButton, offset: 8).bottom(to: navigateButton).width(to: 35).height(to: 35)
    }

    // MARK: - ConfigureUI

    func configureUI() {
        contentView.backgroundColor = .backgroundColor()
        acceptButton.setImage(UIImage(named: "accept"), for: .normal)
        failedButton.setImage(UIImage(named: "failed"), for: .normal)
        navigateButton.setImage(UIImage(named: "navigate"), for: .normal)
        undoButton.setImage(UIImage(named: "undo"), for: .normal)
        undoButton.isHidden = true
    }
    
    // MARK: - Setup Bechavior
    
    func setupBechavior() {
        acceptButton.addTarget(self, action: #selector(didTappedAccept), for: .touchUpInside)
        failedButton.addTarget(self, action: #selector(didTappedFailed), for: .touchUpInside)
        navigateButton.addTarget(self, action: #selector(didTappedNavigate), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(didTappedUndo), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    
    @objc private func didTappedAccept() {
        acceptClosure?()
    }

    @objc private func didTappedFailed() {
        failedClosure?()
    }

    @objc private func didTappedNavigate() {
        navigateClosure?()
    }
    
    @objc private func didTappedUndo() {
        undoClosure?()
    }
    
    // MARK: - API
    
    func setupLabels(numberBuilding: String, street: String, postCode: String, subArea: String, city: String, countRow: Int) {
        adressLabel.text = "\(street), \(numberBuilding)"
        subAdressLabel.text = "\(postCode), \(subArea), \(city)"
        countRowLabel.text = "\(countRow)"
    }
    
    func textInDescriptionView(apartmentNumber: String, clientName: String, tel: String) {
        descriptionView.setText(apartmentNumber: apartmentNumber, clientName: clientName, tel: tel)
    }
    
    func changesHideButton(acceptButtonHide: Bool, failedButtonHide: Bool, navigateButtonHide: Bool, undoButtonHide: Bool) {
        acceptButton.isHidden = acceptButtonHide
        failedButton.isHidden = failedButtonHide
        navigateButton.isHidden = navigateButtonHide
        undoButton.isHidden = undoButtonHide
    }
    
    func labelsOpacity(value: Float) {
        [adressLabel, subAdressLabel, countRowLabel, descriptionView].forEach { $0.layer.opacity = value }
    }
}
