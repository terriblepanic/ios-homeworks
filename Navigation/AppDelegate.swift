//
//  AppDelegate.swift
//  Navigation
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    private let notificationsService = LocalNotificationsService()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        notificationsService.registeForLatestUpdatesIfPossible()

        Task {
            let url = AppConfiguration.allCases.randomElement()?.rawValue ?? ""
            await NetworkService.urlSessionAsync(stringURL: url)
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        try? Auth.auth().signOut()
    }
}
