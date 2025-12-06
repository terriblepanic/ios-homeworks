//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 06/12/2025.
//

import UIKit

class CurrentUserService: UserService {
    private let user: User
    
    init() {
        self.user = User(
            login: "Panic",
            fullName: "Panichkin Kirill",
            avatar: UIImage(named: "teo") ?? UIImage(),
            status: "Ready to help"
        )
    }
    
    func getUser(withLogin login: String) -> User? {
        if login.lowercased() == user.login.lowercased() {
            return user
        }
        return nil
    }
}
