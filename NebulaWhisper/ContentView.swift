import SwiftUI

struct ContentView: View {

    @State private var showHistory = false

    // Анимации
    @State private var didAppear = false
    @State private var planetFloat = false
    @State private var budFloat = false

    private let noteKeys: [String] = (1...120).map { String(format: "note_%03d", $0) }
    private let storage = UserDefaults.standard

    // Цвета
    private let background = Color(red: 249/255, green: 247/255, blue: 241/255) // #F9F7F1
    private let ink = Color(red: 45/255, green: 45/255, blue: 45/255)          // #2D2D2D

    // MARK: - Date keys

    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    private func dayKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private var computedNoteForToday: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % noteKeys.count
        return NSLocalizedString(noteKeys[index], comment: "")
    }

    private var todaysNote: String {
        let key = "note.\(todayKey)"
        if let saved = storage.string(forKey: key) {
            return saved
        } else {
            let note = computedNoteForToday
            storage.set(note, forKey: key)
            return note
        }
    }

    private var todaysDateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }

    private var last7: [(dateText: String, note: String)] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        return (0..<7).compactMap { offset in
            guard let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date()) else { return nil }
            let key = "note.\(dayKey(for: date))"
            let note = storage.string(forKey: key) ?? "—"
            return (formatter.string(from: date), note)
        }
    }

    private func seedLast7IfNeeded() {
        for offset in 0..<7 {
            guard let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date()) else { continue }
            let key = "note.\(dayKey(for: date))"
            if storage.string(forKey: key) == nil {
                let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
                let index = (dayOfYear - 1) % noteKeys.count
                storage.set(NSLocalizedString(noteKeys[index], comment: ""), forKey: key)
            }
        }
    }

    // MARK: - Helpers

    private func clamp(_ value: CGFloat, _ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        min(max(value, minValue), maxValue)
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let safeTop = geo.safeAreaInsets.top
            let safeBottom = geo.safeAreaInsets.bottom

            // Адаптивные метрики (iPhone portrait)
            let leftInset = clamp(w * 0.10, 22, 44)                 // 22..44
            let topBlock = clamp(h * 0.14, 86, 140)                 // позиция текстового блока
            let planetSize = clamp(w * 0.14, 44, 62)                // 44..62

            let budBaseWidth = clamp(w * 0.55, 190, 260)            // ширина бутона
            let budOffsetX = clamp(w * 0.18, 50, 90)                // уход вправо
            let budOffsetY = clamp(h * 0.06, 40, 80)                // уход вниз

            ZStack {
                background.ignoresSafeArea()

                // Планета (левая ось)
                VStack {
                    HStack {
                        Image("Saturn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: planetSize, height: planetSize)
                            .opacity(0.95)
                            .offset(x: -6, y: planetFloat ? -7 : 7)
                            .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true),
                                       value: planetFloat)
                        Spacer()
                    }
                    .padding(.leading, leftInset)
                    .padding(.top, 16 + safeTop * 0.2)

                    Spacer()
                }

                // Текстовый блок (поднятие зависит от высоты экрана)
                VStack(spacing: 0) {
                    Spacer(minLength: topBlock)

                    Text("today_title")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(ink)
                        .padding(.bottom, 22)

                    Text(todaysNote)
                        .font(.system(size: 30, weight: .light, design: .default))
                        .foregroundColor(ink)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, leftInset)
                        .padding(.bottom, 16)
                        .opacity(didAppear ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6), value: didAppear)

                    Text(todaysDateText)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(ink)
                        .opacity(didAppear ? 0.7 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.15), value: didAppear)

                    Spacer()
                }

                // Нижняя зона
                VStack {
                    Spacer()

                    HStack(alignment: .bottom) {
                        Button {
                            showHistory = true
                        } label: {
                            Text("Last 7 Notes")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(ink)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.horizontal, 22)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(background)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(ink.opacity(0.65), lineWidth: 1)
                                )
                        }
                        .padding(.leading, leftInset)
                        .padding(.bottom, 20 + safeBottom * 0.3)

                        Spacer()

                        Image("FlowerBud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: budBaseWidth)
                            .scaleEffect(budFloat ? 1.32 : 1.25)
                            .rotationEffect(.degrees(budFloat ? -26 : -32))
                            .opacity(0.95)
                            .offset(x: budOffsetX, y: budOffsetY)
                            .animation(.easeInOut(duration: 3.4).repeatForever(autoreverses: true),
                                       value: budFloat)
                    }
                }
            }
            .sheet(isPresented: $showHistory) {
                NavigationStack {
                    List {
                        ForEach(last7, id: \.dateText) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.dateText)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(ink)
                                    .opacity(0.85)

                                Text(item.note)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(ink)
                                    .opacity(0.9)

                                Rectangle()
                                    .fill(ink.opacity(0.15))
                                    .frame(height: 0.5)
                                    .padding(.top, 4)
                            }
                            .padding(.vertical, 4)
                            .listRowSeparator(.hidden)
                            .listRowBackground(background)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(background)
                    .navigationTitle("Last 7 Notes")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showHistory = false }
                                .foregroundColor(ink)
                        }
                    }
                }
            }
            .onAppear {
                seedLast7IfNeeded()
                planetFloat = true
                budFloat = true
                didAppear = true
            }
        }
    }
}

#Preview {
    ContentView()
}
