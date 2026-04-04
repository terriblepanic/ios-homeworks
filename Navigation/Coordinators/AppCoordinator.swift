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
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        let feedCoordinator = FeedCoordinator(navigationController: UINavigationController())
        feedCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "text.bubble"),
            selectedImage: UIImage(systemName: "text.bubble.fill")
        )
        
        let favNavController = UINavigationController()
        let favoritesCoordinator = FavoritesCoordinator(navigationController: favNavController)
        favNavController.tabBarItem = UITabBarItem(
            title: "Favourites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        addChildCoordinator(profileCoordinator)
        addChildCoordinator(feedCoordinator)
        addChildCoordinator(favoritesCoordinator)
        
        profileCoordinator.start()
        feedCoordinator.start()
        favoritesCoordinator.start()
        
        tabBarController.viewControllers = [
            profileCoordinator.navigationController,
            feedCoordinator.navigationController,
            favNavController
        ]
        
        self.tabBarController = tabBarController
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
