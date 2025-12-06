//
//  UserService.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 06/12/2025.
//

import Foundation

protocol UserService {
    func getUser(withLogin login: String) -> User?
}
