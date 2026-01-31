//
//  User.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 06/12/2025.
//

import UIKit

class User {
    let login: String
    let fullName: String
    let avatar: UIImage
    let status: String
    
    init(login: String, fullName: String, avatar: UIImage, status: String) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}
