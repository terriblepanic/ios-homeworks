//
//  Checker.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 1/31/26.
//

import Foundation

final class Checker {
    static let shared = Checker()
    
    private let login: String = "test"
    private let password: String = "test"
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {
        return self.login == login && self.password == password
    }
}
