//
//  ContentView.swift
//  Dawnset MVP
//
//  主畫面。顯示 Dawnset 品牌與「開始」按鈕。
//

import SwiftUI

struct ContentView: View {
    @State private var showPipeline = false
    @State private var showAha = false

    var body: some View {
        ZStack {
            // 晨間琥珀色漸層背景
            LinearGradient(
                colors: [
                    Color(hex: "BA7517"),
                    Color(hex: "FAC775")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // 品牌標題
                VStack(spacing: 12) {
                    Text("Dawnset")
                        .font(.system(size: 52, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Everything set by dawn.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()

                // 當前日期與問候
                VStack(spacing: 8) {
                    Text(currentGreeting())
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)

                    Text(formattedDate())
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.75))
                }

                Spacer()

                // 開始按鈕
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showPipeline = true
                }) {
                    HStack {
                        Text("Start Morning Pipeline")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color(hex: "BA7517"))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 18)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                }

                Text("約 4-5 分鐘完成")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))

                Spacer().frame(height: 40)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showPipeline) {
            PipelineView(isPresented: $showPipeline, onComplete: {
                showPipeline = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    showAha = true
                }
            })
        }
        .fullScreenCover(isPresented: $showAha) {
            AhaView(isPresented: $showAha)
        }
    }

    private func currentGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<10: return "早安"
        case 10..<12: return "上午好"
        case 12..<14: return "午安"
        case 14..<18: return "下午好"
        case 18..<22: return "晚上好"
        default: return "夜深了"
        }
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "M 月 d 日 EEEE"
        return formatter.string(from: Date())
    }
}

// MARK: - Color 擴展：支援 hex 顏色
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (255, 255, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

#Preview {
    ContentView()
}
