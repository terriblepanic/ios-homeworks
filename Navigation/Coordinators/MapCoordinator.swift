//
//  MapCoordinator.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 4/5/26.
//

import UIKit

final class MapCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = MapViewController()
        navigationController.setViewControllers([vc], animated: false)
    }
}
