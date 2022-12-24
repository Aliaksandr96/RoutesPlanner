import EasyAutolayout
import UIKit

final class NewRouteTableViewCell: UITableViewCell {
    // MARK: - Private

    private let cellView = UIView()
    private let buildingNumberLabel = UILabel()
    private let streetLabel = UILabel()
    private let postCodeLabel = UILabel()
    private let cityLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: .identifireLocationsTableViewCell)

        setupSubviews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Subviews

    func setupSubviews() {
        [cellView, buildingNumberLabel, streetLabel, postCodeLabel, cityLabel].forEach { contentView.addSubview($0) }
    }

    // MARK: - Setup Constraints

    func setupConstraints() {
        cellView.pin
            .top(to: contentView, offset: 5).leading(to: contentView, offset: 10).trailing(to: contentView, offset: 10).height(to: 90)
        buildingNumberLabel.pin
            .centerY(in: cellView).width(to: cellView, multiplier: 1/4).height(to: cellView).leading(to: cellView, offset: 5)
        streetLabel.pin
            .centerY(in: cellView).width(to: cellView, multiplier: 2/4).height(to: cellView).centerX(in: cellView)
        postCodeLabel.pin
            .trailing(to: cellView, offset: 5).height(to: cellView, multiplier: 1/2).width(to: cellView, multiplier: 1/4).top(to: cellView)
        cityLabel.pin
            .trailing(to: cellView, offset: 5).height(to: cellView, multiplier: 1/2).width(to: cellView, multiplier: 1/4).bottom(to: cellView)
    }

    // MARK: - ConfigureUI

    func configureUI() {
        cellView.backgroundColor = .backgroundColor()
        contentView.backgroundColor = .backgroundColor()
        cellView.layer.cornerRadius = 10
        cellView.layer.borderColor = UIColor.systemBlue.cgColor
        cellView.layer.borderWidth = 1

        [buildingNumberLabel, streetLabel].forEach { $0.textColor = .blackGold() }
        [postCodeLabel, cityLabel].forEach { $0.textColor = .grayWhite() }
        [buildingNumberLabel, streetLabel, postCodeLabel, cityLabel].forEach { $0.numberOfLines = 3 }
        [buildingNumberLabel, streetLabel, postCodeLabel, cityLabel].forEach { $0.textAlignment = .center }
        buildingNumberLabel.font = UIFont.systemFont(ofSize: 26)
    }

    // MARK: - API

    func setupLabels(street: String, buildingNumber: String, postCode: String, city: String) {
        streetLabel.text = street
        buildingNumberLabel.text = buildingNumber
        postCodeLabel.text = postCode
        cityLabel.text = city
    }
}
