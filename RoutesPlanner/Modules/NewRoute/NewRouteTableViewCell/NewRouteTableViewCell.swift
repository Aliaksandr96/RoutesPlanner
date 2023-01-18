import EasyAutolayout
import UIKit

final class NewRouteTableViewCell: UITableViewCell {
    // MARK: - Private
    
    private let cellView : UIView = {
       let view = UIView()
        view.backgroundColor = .backgroundColor()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private let addresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .blackGold()
         return label
     }()
    private let subAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayWhite()
        label.font = UIFont.systemFont(ofSize: 14)
         return label
     }()
    private let countRowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blueGold()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
         return label
     }()

    // MARK: - Initialize
    
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
        [cellView, addresLabel, subAddressLabel,countRowLabel].forEach { contentView.addSubview($0) }
    }

    // MARK: - Setup Constraints

    func setupConstraints() {
        cellView.pin
            .top(to: contentView, offset: 5).leading(to: contentView, offset: 10).trailing(to: contentView, offset: 10).height(to: 52)
        addresLabel.pin
            .top(to: cellView, offset: 3).leading(to: cellView, offset: 15).trailing(to: cellView, offset: 31).height(to: 25)
        countRowLabel.pin
            .after(of: addresLabel, offset: 1).width(to: 25).height(to: 25).top(to: cellView, offset: 3)
        subAddressLabel.pin
            .below(of: addresLabel, offset: 1).leading(to: cellView, offset: 15).trailing(to: cellView, offset: 5).height(to: 15)
    }

    // MARK: - ConfigureUI

    func configureUI() {
        contentView.backgroundColor = .backgroundColor()
    }

    // MARK: - API

    func setupLabels(street: String, buildingNumber: String, postCode: String, city: String, subArea: String, countRow: Int) {
        subAddressLabel.text = "\(postCode), \(subArea), \(city)"
        addresLabel.text = "\(street), \(buildingNumber)"
        countRowLabel.text = "\(countRow)"
    }
}

extension NewRouteTableViewCell {
    
}
