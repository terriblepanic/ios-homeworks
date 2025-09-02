import UIKit

final class ProfileHeaderView: UIView {

    // MARK: Avatar
    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "me")
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    // MARK: Name
    private let name: UILabel = {
        let label = UILabel()
        label.text = "Кирилл Паничкин"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // MARK: Status
    private let status: UILabel = {
        let label = UILabel()
        label.text = "В ожидании чего-то..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()

    // MARK: Status Text Field
    private let statusTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "В ожидании чего-то..."
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()

    // MARK: Button
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Установить статус", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .systemBlue
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        return button
    }()

    private enum Metrics {
        static let padding: CGFloat = 16
        static let avatarSize: CGFloat = 100
    }

    private var statusText: String = ""

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .systemGray6
        setupViews()
        setupActions()
        setupConstraints()
        avatar.layer.cornerRadius = 50
    }

    private func setupViews() {
        [avatar, name, status, statusTextField, button].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupActions() {
        button.addTarget(self, action: #selector(setStatusButtonPressed), for: .touchUpInside)
        statusTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
    }

    // MARK: - Auto Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.padding),
            avatar.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.padding),
            avatar.widthAnchor.constraint(equalToConstant: Metrics.avatarSize),
            avatar.heightAnchor.constraint(equalToConstant: Metrics.avatarSize),

            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Metrics.padding),
            name.topAnchor.constraint(equalTo: avatar.topAnchor, constant: 11),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.padding),

            status.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            status.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            status.trailingAnchor.constraint(equalTo: name.trailingAnchor),

            statusTextField.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            statusTextField.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 11),
            statusTextField.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.padding),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.padding),
            button.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: Metrics.padding),
            button.heightAnchor.constraint(equalToConstant: 50),

            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.padding)
        ])
    }

    @objc private func setStatusButtonPressed() {
        status.text = statusText.isEmpty ? "В ожидании чего-то..." : statusText
        statusTextField.text = ""
        statusText = ""
    }

    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
}
