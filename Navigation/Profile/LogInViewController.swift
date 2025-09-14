import UIKit

final class LogInViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoImageView = UIImageView()
    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        setupConstraints()
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Вход"
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "Logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.placeholder = "Почта или телефон"
        loginTextField.borderStyle = .roundedRect
        loginTextField.font = UIFont.systemFont(ofSize: 16)
        loginTextField.autocorrectionType = .no
        loginTextField.returnKeyType = .next
        loginTextField.delegate = self
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(red: 0x48/255.0, green: 0x85/255.0, blue: 0xCC/255.0, alpha: 1.0)
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(loginTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            loginTextField.topAnchor.constraint(greaterThanOrEqualTo: logoImageView.bottomAnchor, constant: 120),
            loginTextField.centerYAnchor.constraint(greaterThanOrEqualTo: contentView.centerYAnchor, constant: -50),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
    }
    
    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Keyboard Handling
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
        if loginTextField.isFirstResponder {
            scrollToTextField(loginTextField)
        } else if passwordTextField.isFirstResponder {
            scrollToTextField(passwordTextField)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    
    private func scrollToTextField(_ textField: UITextField) {
        let textFieldFrame = textField.convert(textField.bounds, to: scrollView)
        let visibleRect = CGRect(x: 0, y: textFieldFrame.origin.y - 20, width: 1, height: textFieldFrame.height + 40)
        scrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped() {
        navigationController?.navigationBar.isHidden = false
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}
