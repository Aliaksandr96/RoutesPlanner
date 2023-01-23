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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .blueGold()
        return label
    }()
    
    let deliveryComplitedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionView = DescriptionView()
    private let acceptButton = UIButton()
    private let navigateButton = UIButton()
    private let failedButton = UIButton()
    private let undoButton = UIButton()
    
    // MARK: - Variables
    
    var acceptClosure: (() -> Void)?
    var navigateClosure: (() -> Void)?
    var failedClosure: (() -> Void)?
    var undoClosure: (() -> Void)?
    var deliveryStateSetup: Bool = true
    
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
        [cellView, countRowLabel, deliveryComplitedLabel, adressLabel, descriptionView, subAdressLabel, acceptButton, navigateButton, failedButton, undoButton].forEach { contentView.addSubview($0) }
    }

    // MARK: - Setup Constraints

    func setupConstraints() {
        cellView.pin
            .top(to: contentView, offset: 5).leading(to: contentView, offset: 10).trailing(to: contentView, offset: 10).bottom(to: contentView)
        countRowLabel.pin
            .top(to: cellView, offset: 5).leading(to: cellView, offset: 5).height(to: 20).width(to: 20)
        adressLabel.pin
            .top(to: cellView, offset: 5).after(of: countRowLabel, offset: 3).before(of: acceptButton, offset: 2).height(to: 20)
        subAdressLabel.pin
            .below(of: adressLabel, offset: 2).leading(to: adressLabel).before(of: acceptButton, offset: 1).height(to: 16)
        descriptionView.pin
            .below(of: subAdressLabel, offset: 5).leading(to: adressLabel).bottom(to: cellView, offset: 7).before(of: acceptButton, offset: 5)
        acceptButton.pin
            .top(to: cellView, offset: 4).trailing(to: cellView, offset: 5).width(to: 75).height(to: 32)
        failedButton.pin
            .below(of: acceptButton, offset: 4).trailing(to: cellView, offset: 5).width(to: 75).height(to: 32)
        navigateButton.pin
            .below(of: failedButton, offset: 4).trailing(to: cellView, offset: 5).width(to: 75).height(to: 32)
        undoButton.pin
            .below(of: failedButton, offset: 4).trailing(to: cellView, offset: 5).width(to: 75).height(to: 32)
        deliveryComplitedLabel.pin
            .above(of: navigateButton, offset: 5).height(to: 20).width(to: navigateButton).trailing(to: cellView, offset: 5)
    }

    // MARK: - ConfigureUI

    func configureUI() {
        contentView.backgroundColor = .backgroundColor()
        countRowLabel.textColor = .blueGold()
        createCellButton(button: acceptButton, systemImageName: "shippingbox", imageColor: .pinGreen(), textTitle: "Accept", tintText: .blueGold())
        createCellButton(button: failedButton, systemImageName: "shippingbox", imageColor: .pinRed(), textTitle: "Failed", tintText: .blueGold())
        createCellButton(button: navigateButton, systemImageName: "location.fill", imageColor: .white, textTitle: "Navigate", tintText: .white)
        createCellButton(button: undoButton, systemImageName: "arrowshape.turn.up.left.fill", imageColor: .white, textTitle: "Undo", tintText: .white)
        navigateButton.backgroundColor = .pinBlue()
        undoButton.backgroundColor = .pinBlue()
        undoButton.isHidden = true
        deliveryComplitedLabel.isHidden = true
        descriptionView.isEditableView(state: false)
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
    
    func changesHideButton(acceptButtonHide: Bool, failedButtonHide: Bool, navigateButtonHide: Bool, undoButtonHide: Bool, deliveryLabel: Bool) {
        acceptButton.isHidden = acceptButtonHide
        failedButton.isHidden = failedButtonHide
        navigateButton.isHidden = navigateButtonHide
        undoButton.isHidden = undoButtonHide
        deliveryComplitedLabel.isHidden = deliveryLabel
    }
    
    func labelsOpacity(value: Float) {
        [adressLabel, subAdressLabel, countRowLabel, descriptionView].forEach { $0.layer.opacity = value }
    }
    
    func deliveryLabelState(state: Bool) {
        if state == true {
            deliveryComplitedLabel.text = "Complete"
            deliveryComplitedLabel.textColor = .pinGreen()
        }
        if state == false {
            deliveryComplitedLabel.text = "Failed"
            deliveryComplitedLabel.textColor = .pinRed()
        }
    }
}

extension LocationsTableViewCell {
    private func createCellButton(button: UIButton, systemImageName: String, imageColor: UIColor, textTitle: String, tintText: UIColor) {
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        let configuration = UIImage.SymbolConfiguration(pointSize: 11, weight: .light)
        var borderlessConfigure = UIButton.Configuration.borderless()
        borderlessConfigure.attributedTitle = AttributedString(textTitle,
                                                               attributes: .init([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
                                                                                  NSAttributedString.Key.foregroundColor: tintText]))
        borderlessConfigure.image = UIImage(systemName: systemImageName, withConfiguration: configuration)?.withTintColor(imageColor, renderingMode: .alwaysOriginal)
        borderlessConfigure.imagePlacement = .top
        borderlessConfigure.imagePadding = 1
        button.configuration = borderlessConfigure
    }
}
