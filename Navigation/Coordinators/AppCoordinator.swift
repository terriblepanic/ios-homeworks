//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/2/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let window: UIWindow
    private var tabBarController: UITabBarController?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        let feedCoordinator = FeedCoordinator(navigationController: UINavigationController())
        
        addChildCoordinator(profileCoordinator)
        addChildCoordinator(feedCoordinator)
        
        profileCoordinator.start()
        feedCoordinator.start()
        
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        feedCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "text.bubble"),
            selectedImage: UIImage(systemName: "text.bubble.fill")
        )
        
        tabBarController.viewControllers = [
            profileCoordinator.navigationController,
            feedCoordinator.navigationController
        ]
        
        self.tabBarController = tabBarController
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
