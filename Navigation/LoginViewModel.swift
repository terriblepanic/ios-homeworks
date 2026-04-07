//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 4/6/26.
//

import Foundation

enum LoginState: Equatable {
    case idle
    case success
    case failure(message: String)
}

final class LoginViewModel {

    private let loginDelegate: LoginViewControllerDelegate
    private(set) var state: LoginState = .idle

    var onStateChanged: ((LoginState) -> Void)?

    init(loginDelegate: LoginViewControllerDelegate) {
        self.loginDelegate = loginDelegate
    }

    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            state = .failure(message: "Введите email и пароль")
            onStateChanged?(state)
            return
        }

        loginDelegate.checkCredentials(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.state = .success
                self.onStateChanged?(self.state)
            case .failure(let error):
                let nsError = error as NSError
                
                if nsError.code == 17011 {
                    self.signUp(email: email, password: password)
                } else {
                    self.state = .failure(message: error.localizedDescription)
                    self.onStateChanged?(self.state)
                }
            }
        }
    }

    private func signUp(email: String, password: String) {
        loginDelegate.signUp(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.state = .success
                self.onStateChanged?(self.state)
            case .failure(let error):
                self.state = .failure(message: error.localizedDescription)
                self.onStateChanged?(self.state)
            }
        }
    }
}
