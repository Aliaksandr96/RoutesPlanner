import UIKit

final class DetailsTextField: UIView {
    
    var text: String {
        mainTextField.text ?? ""
    }
    
    var isAutocorrectionEnabled = true {
        didSet {
            mainTextField.autocorrectionType = isAutocorrectionEnabled ? .yes : .no
        }
    }
    
    private let titleLabel = UILabel()
    private let mainTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        configureUI()
    }
    private func setupSubviews() {
        addSubview(mainTextField)
        addSubview(titleLabel)
    }
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -8).isActive = true
        
        mainTextField.translatesAutoresizingMaskIntoConstraints = false
        mainTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        mainTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        mainTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        mainTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
    }
    private func configureUI() {
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .blackGold()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.cornerRadius = 15
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setPlaceholder(_ placeHolder: String) {
        mainTextField.placeholder = placeHolder
    }
    func setKeyboardType(_ type: UIKeyboardType) {
        mainTextField.keyboardType = type
    }
}
