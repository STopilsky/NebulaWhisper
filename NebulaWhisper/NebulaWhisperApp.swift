import SwiftUI

@main
struct NebulaWhisperApp: App {

    @AppStorage("didFinishOnboarding") private var didFinishOnboarding: Bool = false
    @AppStorage("didAskNotifications") private var didAskNotifications: Bool = false


    var body: some Scene {
        WindowGroup {
            if !didFinishOnboarding {
                OnboardingView {
                    didFinishOnboarding = true
                }
            } else if !didAskNotifications {
                NotificationPromptView(
                    onEnable: {
                        didAskNotifications = true
                        NotificationManager.requestPermissionAndSchedule()
                    },
                    onSkip: {
                        didAskNotifications = true
                    }
                )
            } else {
                ContentView()
            }
        }
    }
}
