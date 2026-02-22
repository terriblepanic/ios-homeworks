//
//  Todo.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/21/26.
//

import Foundation

struct Todo {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    init?(from dictionary: [String: Any]) {
        guard let userId = dictionary["userId"] as? Int,
              let id = dictionary["id"] as? Int,
              let title = dictionary["title"] as? String,
              let completed = dictionary["completed"] as? Bool else {
            return nil
        }
        
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }
}
