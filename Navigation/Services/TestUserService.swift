//
//  TestUserService.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 06/12/2025.
//

import UIKit

class TestUserService: UserService {
    private let testUser: User
    
    init() {
        self.testUser = User(
            login: "Test",
            fullName: "Test User",
            avatar: UIImage(systemName: "person.circle.fill") ?? UIImage(),
            status: "Test mode active"
        )
    }
    
    func getUser(withLogin login: String) -> User? {
        return testUser
    }
}
