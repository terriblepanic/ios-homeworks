//
//  LoginInspector.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 1/31/26.
//

import Foundation

final class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        Checker.shared.check(login: login, password: password)
    }
}
