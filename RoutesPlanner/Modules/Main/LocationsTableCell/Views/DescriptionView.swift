import UIKit

class DescriptionView: UIView {
    // MARK: - Private
    
    let notesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text")
        imageView.tintColor = .blueGold()
        return imageView
    }()

    let notesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        backgroundColor = .systemGray5
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Subviews

    private func setupSubviews() {
        [notesImage, notesLabel].forEach { addSubview($0) }
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        notesImage.translatesAutoresizingMaskIntoConstraints = false
        notesImage.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        notesImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        notesImage.widthAnchor.constraint(equalToConstant: 13).isActive = true
        notesImage.heightAnchor.constraint(equalToConstant: 13).isActive = true

        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        notesLabel.leadingAnchor.constraint(equalTo: notesImage.trailingAnchor, constant: 3).isActive = true
        notesLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        notesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
    }

    // MARK: - API

    func setText(apartmentNumber: String, clientName: String, tel: String) {
        if apartmentNumber.isEmpty && clientName.isEmpty && tel.isEmpty {
            notesLabel.text = "Add Notes..."
        } else {
            notesLabel.text = "flat: \(apartmentNumber), name: \(clientName), tel:\(tel)"
        }
    }
}
