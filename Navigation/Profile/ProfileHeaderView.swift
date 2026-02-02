//
//  ProfileHeaderView.swift
//  Navigation
//

import UIKit
import SnapKit

final class ProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Visual objects
    var onStatusUpdate: ((String) -> Void)?
    
    var fullNameLabel = UILabel()
    var avatarImageView = UIImageView()
    var statusLabel = UILabel()
    var statusTextField = UITextField()
    var setStatusButton = UIButton()
    var returnAvatarButton = UIButton()
    var avatarBackground = UIView()
    
    private var statusText = "Ready to help"
    private var avatarOriginPoint = CGPoint()
    
    // Constraints для анимации аватарки
    private var avatarTopConstraint: Constraint?
    private var avatarLeadingConstraint: Constraint?
    private var avatarWidthConstraint: Constraint?
    private var avatarHeightConstraint: Constraint?
    
    // MARK: - Configuration
    
    func configure(with user: User) {
        fullNameLabel.text = user.fullName
        avatarImageView.image = user.avatar
        statusLabel.text = user.status
        statusText = user.status
    }
    
    // MARK: - Setup section
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupNameLabel()
        setupStatusLabel()
        setupStatusTextField()
        setupStatusButton()
        setupAvatarImage()
        
        statusTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("lol")
    }
    
    private func setupNameLabel() {
        fullNameLabel.font = .boldSystemFont(ofSize: 18)
        fullNameLabel.textColor = .black
        addSubview(fullNameLabel)
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).offset(156)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(28)
        }
    }
    
    private func setupStatusLabel() {
        statusLabel.font = .systemFont(ofSize: 17)
        statusLabel.textColor = .black
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(16)
            make.leading.equalTo(fullNameLabel)
            make.trailing.equalTo(fullNameLabel)
            make.height.equalTo(fullNameLabel)
        }
    }
    
    private func setupStatusTextField() {
        statusTextField.textColor = .darkGray
        statusTextField.backgroundColor = .white
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        statusTextField.leftView = paddingView
        statusTextField.leftViewMode = .always
        statusTextField.layer.cornerRadius = 8
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.gray.cgColor
        statusTextField.attributedPlaceholder = NSAttributedString(string: "Ready...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        statusTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        addSubview(statusTextField)
        
        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.leading.equalTo(fullNameLabel)
            make.trailing.equalTo(fullNameLabel)
            make.height.equalTo(32)
        }
    }
    
    private func setupStatusButton() {
        setStatusButton.backgroundColor = .systemBlue
        setStatusButton.layer.cornerRadius = LayoutConstants.cornerRadius
        setStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.layer.shadowOpacity = 0.7
        setStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        setStatusButton.setTitle("Show status", for: .normal)
        setStatusButton.setTitleColor(.white, for: .normal)
        setStatusButton.addTarget(self, action: #selector(statusButtonPressed), for: .touchUpInside)
        addSubview(setStatusButton)
        
        setStatusButton.snp.makeConstraints { make in
            make.top.equalTo(statusTextField.snp.bottom).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    private func setupAvatarImage() {
        avatarImageView.layer.cornerRadius = 64
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        
        // add a tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnAvatar))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        
        // cancel an animation mode
        returnAvatarButton.alpha = 0
        returnAvatarButton.backgroundColor = .clear
        returnAvatarButton.contentMode = .scaleToFill
        returnAvatarButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.black, renderingMode: .automatic), for: .normal)
        returnAvatarButton.tintColor = .black
        returnAvatarButton.addTarget(self, action: #selector(returnAvatarToOrigin), for: .touchUpInside)
        
        // translucent background for the modal animation mode
        avatarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        avatarBackground.backgroundColor = .darkGray
        avatarBackground.isHidden = true
        avatarBackground.alpha = 0
        
        addSubviews(avatarBackground, avatarImageView, returnAvatarButton)
        
        avatarImageView.snp.makeConstraints { make in
            avatarTopConstraint = make.top.equalTo(safeAreaLayoutGuide).offset(16).constraint
            avatarLeadingConstraint = make.leading.equalTo(safeAreaLayoutGuide).offset(16).constraint
            avatarWidthConstraint = make.width.height.equalTo(128).constraint
            avatarHeightConstraint = make.height.equalTo(128).constraint
        }
        
        returnAvatarButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    // MARK: - Event handlers
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
    @objc private func statusButtonPressed() {
        statusLabel.text = statusText
        onStatusUpdate?(statusText)
    }
    
    @objc private func didTapOnAvatar() {
        // create an animation
        avatarImageView.isUserInteractionEnabled = false
        
        ProfileViewController.postTableView.isScrollEnabled = false
        ProfileViewController.postTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = false
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        avatarTopConstraint?.update(offset: 0)
        avatarLeadingConstraint?.update(offset: 0)
        avatarWidthConstraint?.update(offset: screenWidth)
        avatarHeightConstraint?.update(offset: screenWidth)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.avatarImageView.layer.cornerRadius = 0
            self.avatarBackground.isHidden = false
            self.avatarBackground.alpha = 0.7
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.returnAvatarButton.alpha = 1
            }
        }
    }
    
    @objc private func returnAvatarToOrigin() {
        avatarTopConstraint?.update(offset: 16)
        avatarLeadingConstraint?.update(offset: 16)
        avatarWidthConstraint?.update(offset: 128)
        avatarHeightConstraint?.update(offset: 128)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.returnAvatarButton.alpha = 0
            self.avatarImageView.layer.cornerRadius = 64
            self.avatarBackground.alpha = 0
            self.layoutIfNeeded()
        } completion: { _ in
            self.avatarBackground.isHidden = true
            ProfileViewController.postTableView.isScrollEnabled = true
            ProfileViewController.postTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
            self.avatarImageView.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Extension

extension ProfileHeaderView: UITextFieldDelegate {
    
    // tap 'done' on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
