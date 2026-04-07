//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 4/6/26.
//

import UserNotifications

final class LocalNotificationsService {

    func registeForLatestUpdatesIfPossible() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { granted, error in
            guard granted else { return }
            self.scheduleLatestUpdatesNotification()
        }
    }

    private func scheduleLatestUpdatesNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Посмотрите последние обновления"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "latestUpdates", content: content, trigger: trigger)
        center.add(request)
    }
}
