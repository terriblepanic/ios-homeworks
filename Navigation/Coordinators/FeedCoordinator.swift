//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/2/26.
//

import UIKit
import StorageService

final class FeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFeed()
    }
    
    private func showFeed() {
        let feedVC = FeedViewController()
        feedVC.coordinator = self
        navigationController.setViewControllers([feedVC], animated: false)
    }
    
    func showPost(_ post: Post) {
        let postVC = PostViewController()
        postVC.post = post
        postVC.coordinator = self
        navigationController.pushViewController(postVC, animated: true)
    }
    
    func showInfo() {
        let infoVC = InfoViewController()
        navigationController.present(infoVC, animated: true)
    }
}
