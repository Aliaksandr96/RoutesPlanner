import EasyAutolayout
import UIKit

final class LocationsTableViewCell: UITableViewCell {
    // MARK: - Private
    
    private let cellView = UIView()
    private let numberBuildingLabel = UILabel()
    private let streetLabel = UILabel()
    private let postCodeLabel = UILabel()
    private let subAreaLabel = UILabel()
    private let cityLabel = UILabel()
    
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
        [cellView, numberBuildingLabel, streetLabel, postCodeLabel, subAreaLabel, cityLabel, acceptButton, navigateButton, failedButton, undoButton].forEach { contentView.addSubview($0) }
    }

    // MARK: - Setup Constraints

    func setupConstraints() {
        cellView.pin
            .top(to: contentView).leading(to: contentView, offset: 10).trailing(to: contentView, offset: 10).height(to: 90)
        numberBuildingLabel.pin
            .top(to: cellView, offset: 4).leading(to: cellView, offset: 4).width(to: cellView, multiplier: 1/4.5).height(to: cellView, multiplier: 1/3)
        streetLabel.pin
            .after(of: numberBuildingLabel, offset: 3).height(to: cellView, multiplier: 1/3).trailing(to: cellView, offset: 4).top(to: cellView, offset: 4)
        postCodeLabel.pin
            .below(of: numberBuildingLabel, offset: 3).leading(to: numberBuildingLabel).width(to: cellView, multiplier: 1/5).bottom(to: cellView, offset: 4)
        subAreaLabel.pin
            .after(of: postCodeLabel, offset: 3).width(to: cellView, multiplier: 1/5).below(of: numberBuildingLabel, offset: 3).bottom(to: cellView, offset: 4)
        cityLabel.pin
            .after(of: subAreaLabel, offset: 3).width(to: cellView, multiplier: 1/5).below(of: numberBuildingLabel, offset: 3).bottom(to: cellView, offset: 4)
        navigateButton.pin
            .bottom(to: cellView, offset: 12).trailing(to: cellView, offset: 8).width(to: 35).height(to: 35)
        failedButton.pin
            .before(of: navigateButton, offset: 8).bottom(to: navigateButton).width(to: 35).height(to: 35)
        acceptButton.pin
            .before(of: failedButton, offset: 8).bottom(to: navigateButton).width(to: 35).height(to: 35)
        undoButton.pin
            .before(of: navigateButton, offset: 8).bottom(to: navigateButton).width(to: 35).height(to: 35)
    }

    // MARK: - ConfigureUI

    func configureUI() {
        cellView.backgroundColor = .backgroundColor()
        contentView.backgroundColor = .backgroundColor()
        cellView.layer.cornerRadius = 10
        cellView.layer.borderColor = UIColor.systemBlue.cgColor
        cellView.layer.borderWidth = 1
        
        [postCodeLabel, cityLabel, subAreaLabel].forEach { $0.textColor = .grayWhite() }
        [numberBuildingLabel, streetLabel, postCodeLabel, subAreaLabel, cityLabel].forEach { $0.numberOfLines = 3 }
        [numberBuildingLabel, postCodeLabel, subAreaLabel, cityLabel].forEach { $0.textAlignment = .center }
        [postCodeLabel, subAreaLabel, cityLabel].forEach { $0.font = UIFont.systemFont(ofSize: 13) }
        streetLabel.textColor = .blackGold()
        streetLabel.font = UIFont.systemFont(ofSize: 18)
        
        numberBuildingLabel.textColor = .blueGold()
        numberBuildingLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
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
    
    func setupLabels(numberBuilding: String, street: String, postCode: String, subArea: String, city: String) {
        numberBuildingLabel.text = numberBuilding
        streetLabel.text = street
        postCodeLabel.text = postCode
        subAreaLabel.text = subArea
        cityLabel.text = city
    }
    
    func changesHideButton(acceptButtonHide: Bool, failedButtonHide: Bool, navigateButtonHide: Bool, undoButtonHide: Bool) {
        acceptButton.isHidden = acceptButtonHide
        failedButton.isHidden = failedButtonHide
        navigateButton.isHidden = navigateButtonHide
        undoButton.isHidden = undoButtonHide
    }
    
    func labelsOpacity(value: Float) {
        [streetLabel, numberBuildingLabel, postCodeLabel, cityLabel, subAreaLabel].forEach { $0.layer.opacity = value }
    }
}
