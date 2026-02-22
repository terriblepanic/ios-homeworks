//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/22/26.
//

import Foundation

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}
