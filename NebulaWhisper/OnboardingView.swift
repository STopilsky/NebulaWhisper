import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void

    // Основной цвет текста и кнопок: #2D2D2D
    private let ink = Color(red: 45/255, green: 45/255, blue: 45/255)

    // Цвет фона
    private let background = Color(red: 249/255, green: 247/255, blue: 241/255)

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer(minLength: 56)

                // Заголовок — чуть жирнее
                Text("Nebula Whisper")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(ink)
                    .padding(.bottom, 44)

                // Иллюстрация
                Image("OnboardingIllustration")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 270)
                    .padding(.bottom, 64) // +12 к предыдущему отступу

                // Описательный текст — тоньше, но не меньше
                Text("Ancient cosmic\nwisdom for a\nharmonious life")
                    .font(.system(size: 30, weight: .light, design: .default))
                    .foregroundColor(ink)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 56)

                Spacer()

                // Continue — primary
                Button(action: onFinish) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ink)
                        .cornerRadius(18)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 14)

                // Skip — secondary
                Button(action: onFinish) {
                    Text("Skip")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(ink)
                        .opacity(0.75)
                }
                .padding(.bottom, 34)
            }
        }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
