//
//  AhaView.swift
//  Dawnset MVP
//
//  「一切就位」aha 完成畫面。這是整個 App 最重要的情感時刻。
//

import SwiftUI

struct AhaView: View {
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // 成就綠漸層
            LinearGradient(
                colors: [
                    Color(hex: "0F6E56"),
                    Color(hex: "E1F5EE")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // 大勾勾
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                .opacity(opacity)

                VStack(spacing: 14) {
                    Text("Everything is set.")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("晨間流程完成。一切必要的都搞定了。")
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.92))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(opacity)

                Spacer()

                Text("今天你多活了幾秒")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))

                Text("+4 分鐘")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(opacity)

                Spacer()

                // 出發按鈕
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    isPresented = false
                }) {
                    HStack {
                        Text("出發")
                            .font(.system(size: 19, weight: .semibold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color(hex: "0F6E56"))
                    .padding(.horizontal, 56)
                    .padding(.vertical, 18)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 14, x: 0, y: 6)
                }
                .opacity(opacity)

                Text("Dawnset 已完成任務，它現在退場。")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.65))
                    .padding(.top, 8)
                    .opacity(opacity)

                Spacer().frame(height: 40)
            }
            .padding()
        }
        .onAppear {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    AhaView(isPresented: .constant(true))
}
