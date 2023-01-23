import UIKit

final class DescriptionView: UIView {
    // MARK: - Private

    private let notesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text")
        imageView.tintColor = .blueGold()
        return imageView
    }()

    private let notesTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = .blackGold()
        textView.backgroundColor = .grayTextViewBackground()
        return textView
    }()
    
    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Subviews

    private func setupSubviews() {
        [notesImage, notesTextView].forEach { addSubview($0) }
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        notesImage.translatesAutoresizingMaskIntoConstraints = false
        notesImage.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        notesImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        notesImage.widthAnchor.constraint(equalToConstant: 14).isActive = true
        notesImage.heightAnchor.constraint(equalToConstant: 14).isActive = true

        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: notesImage.trailingAnchor, constant: 3).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        notesTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
    }

    // MARK: - API

    func setText(apartmentNumber: String, clientName: String, tel: String) {
        if apartmentNumber.isEmpty, clientName.isEmpty, tel.isEmpty {
            notesTextView.text = "Add Notes..."
        } else {
            notesTextView.text = "flat: \(apartmentNumber), name: \(clientName), tel:\(tel)"
        }
    }
    
    func isEditableView(state: Bool) {
        notesTextView.isEditable = state
    }
}
