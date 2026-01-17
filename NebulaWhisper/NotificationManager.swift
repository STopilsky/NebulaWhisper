import UserNotifications

enum NotificationManager {

    static func requestPermissionAndSchedule() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                scheduleDaily()
            }
        }
    }

    private static func scheduleDaily() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let content = UNMutableNotificationContent()
        content.title = "Today’s Note"
        content.body = "Your daily note is ready."

        let request = UNNotificationRequest(
            identifier: "daily_note",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }
}
