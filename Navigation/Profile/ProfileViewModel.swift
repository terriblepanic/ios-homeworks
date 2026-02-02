//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/2/26.
//

import UIKit
import StorageService

// MARK: - Protocols

protocol ProfileViewModelInput {
    var user: User? { get }
    var posts: [Post] { get }
    func updateStatus(_ newStatus: String)
}

protocol ProfileViewModelOutput: AnyObject {
    func didUpdateStatus(_ status: String)
}

// MARK: - ViewModel

final class ProfileViewModel {
    
    // MARK: - Properties
    
    weak var output: ProfileViewModelOutput?
    
    private var currentUser: User?
    private let userService: UserService
    
    // MARK: - Init
    
    init(user: User?, userService: UserService) {
        self.currentUser = user
        self.userService = userService
    }
}

// MARK: - ProfileViewModelInput

extension ProfileViewModel: ProfileViewModelInput {
    
    var user: User? {
        return currentUser
    }
    
    var posts: [Post] {
        return postExamples
    }
    
    func updateStatus(_ newStatus: String) {
        currentUser?.status = newStatus
        output?.didUpdateStatus(newStatus)
    }
}
