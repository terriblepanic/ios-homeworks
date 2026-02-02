//
//  LoginFactory.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 1/31/26.
//

import Foundation

protocol LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate
}
