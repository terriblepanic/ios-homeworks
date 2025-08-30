import UIKit

class ProfileHeaderView: UIView {
    // MARK: Avatar
    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "me")
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
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
    
    // MARK: Button
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Установить статус", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .blue
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        return button
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
    
    private var statusText: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        addSubview(avatar)
        addSubview(name)
        addSubview(status)
        addSubview(button)
        addSubview(statusTextField)
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        statusTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 16
        
        avatar.frame = CGRect(x: padding, y: padding, width: 100, height: 100)
        
        let nameX = avatar.frame.maxX + padding
        let nameWidth = bounds.width - nameX - padding
        name.frame = CGRect(x: nameX, y: 27, width: nameWidth, height: 18)
        
        let statusX = nameX
        let statusWidth = nameWidth
        let statusY = name.frame.maxY + 8
        status.frame = CGRect(x: statusX, y: statusY, width: statusWidth, height: 14)
        
        let textFieldY = status.frame.maxY + 11
        statusTextField.frame = CGRect(x: statusX, y: textFieldY, width: statusWidth, height: 40)
        
        let buttonY = statusTextField.frame.maxY + padding
        let buttonWidth = bounds.width - 2 * padding
        button.frame = CGRect(x: padding, y: buttonY, width: buttonWidth, height: 50)
    }
    
    @objc private func buttonPressed() {
        status.text = statusText
        statusTextField.text = ""
    }
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
}
