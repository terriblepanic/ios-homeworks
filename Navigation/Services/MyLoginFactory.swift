//
//  MyLoginFactory.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 1/31/26.
//

import Foundation

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate {
        print("DEBUG: Creating LoginInspector")
        return LoginInspector()
    }
}
