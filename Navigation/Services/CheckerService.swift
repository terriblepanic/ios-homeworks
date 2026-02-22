//
//  CheckerService.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/22/26.
//

import FirebaseAuth

final class CheckerService: CheckerServiceProtocol {

    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                let nsError = error as NSError
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
