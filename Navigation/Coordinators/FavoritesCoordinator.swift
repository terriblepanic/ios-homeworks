//
//  FavoritesCoordinator.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/24/26.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FavoritesViewController()
        navigationController.setViewControllers([vc], animated: false)
    }
}
