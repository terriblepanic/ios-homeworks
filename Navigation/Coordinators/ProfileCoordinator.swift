//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/2/26.
//

import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    func didFinishProfile()
}

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: ProfileCoordinatorDelegate?
    
    private let loginFactory: LoginFactory
    private var loginInspector: LoginViewControllerDelegate?
    
    init(navigationController: UINavigationController, loginFactory: LoginFactory = MyLoginFactory()) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
    }
    
    func start() {
        showLogin()
    }
    
    private func showLogin() {
        loginInspector = loginFactory.makeLoginInspector()
        let loginVC = LoginViewController(loginDelegate: loginInspector)
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    func showProfile(with user: User, userService: UserService) {
        let viewModel = ProfileViewModel(user: user, userService: userService)
        let profileVC = ProfileViewController(viewModel: viewModel)
        viewModel.output = profileVC
        profileVC.coordinator = self
        
        navigationController.setViewControllers([profileVC], animated: true)
    }
    
    func showPhotos() {
        let photosVC = PhotosViewController()
        navigationController.pushViewController(photosVC, animated: true)
    }
}
