//
//  LoginInspector.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 1/31/26.
//

import Foundation

final class LoginInspector: LoginViewControllerDelegate {

    private let checkerService: CheckerServiceProtocol = CheckerService()

    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkerService.checkCredentials(email: email, password: password, completion: completion)
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkerService.signUp(email: email, password: password, completion: completion)
    }
}
