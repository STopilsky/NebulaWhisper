import SwiftUI

struct NotificationPromptView: View {
    let onEnable: () -> Void
    let onSkip: () -> Void

    var body: some View {
        ZStack {
            Color(red: 249/255, green: 247/255, blue: 241/255)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                Text("notifications_title")
                    .font(.system(size: 24, weight: .semibold))
                    .multilineTextAlignment(.center)

                Text("notifications_body")
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .opacity(0.85)
                    .padding(.horizontal, 24)

                Spacer()

                Button(action: onEnable) {
                    Text("notifications_enable")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.black.opacity(0.08))
                        .cornerRadius(14)
                }
                .padding(.horizontal, 24)

                Button(action: onSkip) {
                    Text("notifications_skip")
                        .opacity(0.7)
                }
                .padding(.bottom, 24)
            }
            .foregroundColor(.black)
        }
    }
}
