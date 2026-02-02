//
//  FeedViewController.swift
//  Navigation
//

import UIKit
import StorageService

final class FeedViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator?
    private let feedModel = FeedModel()
    
    private lazy var secretWordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter secret word"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textAlignment = .center
        return textField
    }()
    
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(
            title: "Check",
            backgroundColor: .systemOrange
        ) { [weak self] in
            self?.checkWord()
        }
        return button
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter a word and check"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        
        setupNotifications()
        createSubView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCheckResult(_:)),
            name: FeedModel.checkResultNotification,
            object: nil
        )
    }
    
    private func createSubView() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])
        
        let button1 = CustomButton(
            title: "Post number One",
            backgroundColor: .systemPurple
        ) { [weak self] in
            self?.tapPostButton()
        }
        
        let button2 = CustomButton(
            title: "Post number Two",
            backgroundColor: .systemIndigo
        ) { [weak self] in
            self?.tapPostButton()
        }
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        
        view.addSubviews(secretWordTextField, checkGuessButton, resultLabel)
        
        NSLayoutConstraint.activate([
            secretWordTextField.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            secretWordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            secretWordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            secretWordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            checkGuessButton.topAnchor.constraint(equalTo: secretWordTextField.bottomAnchor, constant: 16),
            checkGuessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkGuessButton.widthAnchor.constraint(equalToConstant: 150),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func checkWord() {
        guard let word = secretWordTextField.text, !word.isEmpty else {
            resultLabel.text = "Enter a word!"
            resultLabel.textColor = .orange
            return
        }
        
        feedModel.check(word: word)
    }
    
    @objc private func handleCheckResult(_ notification: Notification) {
        guard let isCorrect = notification.userInfo?[FeedModel.resultKey] as? Bool else {
            return
        }
        
        if isCorrect {
            resultLabel.text = "✓ Right!"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "✗ Wrong"
            resultLabel.textColor = .systemRed
        }
    }

    private func addPostButton(title: String, color: UIColor, to view: UIStackView, selector: Selector) {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = LayoutConstants.cornerRadius
        button.addTarget(self, action: selector, for: .touchUpInside)
        view.addArrangedSubview(button)
    }
    
    @objc func tapPostButton() {
        let post = postExamples[0]
        coordinator?.showPost(post)
    }
}

