import EasyAutolayout
import UIKit

final class RoutesTableCell: UITableViewCell {
    
    // MARK: - Private
    
    private let cellView = UIView()
    private let routeNameLabel = UILabel()
    private let routeDateLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: .identifireRoutesTableCell)

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
        [cellView, routeNameLabel, routeDateLabel].forEach { contentView.addSubview($0) }
    }

    // MARK: - Setup Constraints

    func setupConstraints() {
        cellView.pin
            .top(to: contentView, offset: 10).leading(to: contentView, offset: 10).trailing(to: contentView, offset: 10).height(to: 50)
        routeNameLabel.pin
            .centerY(in: cellView).leading(to: cellView, offset: 5).height(to: cellView).width(to: cellView, multiplier: 1/2)
        routeDateLabel.pin
            .centerY(in: cellView).trailing(to: cellView, offset: 10).height(to: cellView).width(to: cellView, multiplier: 1/2)
    }

    // MARK: - ConfigureUI

    func configureUI() {
        cellView.layer.cornerRadius = 10
        cellView.layer.borderColor = UIColor.systemBlue.cgColor
        cellView.layer.borderWidth = 1
        
        cellView.backgroundColor = .backgroundColor()
        contentView.backgroundColor = .backgroundColor()
        
        routeDateLabel.textAlignment = .right
        routeNameLabel.textAlignment = .center
        
        routeDateLabel.textColor = .grayWhite()
        routeNameLabel.textColor = .blackGold()
        
        [routeNameLabel, routeDateLabel].forEach { $0.font = UIFont.systemFont(ofSize: 16) }
    }
    
    // MARK: - API
    
    func setupLabels(routeName: String, routeDate: String) {
        routeDateLabel.text = routeDate
        routeNameLabel.text = routeName
    }
}
