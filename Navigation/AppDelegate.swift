//
//  AppDelegate.swift
//  Navigation
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appConfiguration: AppConfiguration?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configurations: [AppConfiguration] = [
            .people("8"),
            .starships("3"),
            .planets("5")
        ]
        
        appConfiguration = configurations.randomElement()
        
        if let config = appConfiguration {
            NetworkService.request(for: config) { result in
                switch result {
                case .success(let json):
                    print("\nJSON успешно получен")
                    if let name = json["name"] {
                        print("Name: \(name)")
                    }
                case .failure(let error):
                    print("\nОшибка: \(error)")
                }
            }
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        return true
    }
}
