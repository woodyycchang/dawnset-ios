//
//  PipelineView.swift
//  Dawnset MVP
//
//  Pipeline 執行畫面。一步一步帶使用者走完。
//

import SwiftUI

struct PipelineView: View {
    @Binding var isPresented: Bool
    let onComplete: () -> Void

    @State private var currentStepIndex = 0
    @State private var remainingSeconds = 60
    @State private var timer: Timer?
    @State private var isRunning = false

    private let steps = MorningPipeline.steps

    var currentStep: PipelineStep {
        steps[currentStepIndex]
    }

    var progress: Double {
        Double(currentStepIndex) / Double(steps.count)
    }

    var body: some View {
        ZStack {
            // 背景
            LinearGradient(
                colors: [
                    Color(hex: "BA7517").opacity(0.9),
                    Color(hex: "FAC775").opacity(0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // 頂部：關閉 + 進度
                HStack {
                    Button(action: {
                        stopTimer()
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("\(currentStepIndex + 1) / \(steps.count)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())

                    Spacer()

                    // 占位保持對稱
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // 進度條
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white)
                            .frame(width: geo.size.width * progress, height: 4)
                            .animation(.spring(response: 0.4), value: progress)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()

                // 步驟內容
                VStack(spacing: 24) {
                    // 研究標記
                    if currentStep.hasResearch {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: "0F6E56"))
                                .frame(width: 8, height: 8)
                            Text("研究支持")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Capsule())
                    }

                    Text(currentStep.title)
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(currentStep.subtitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                // 計時器
                VStack(spacing: 16) {
                    Text(timeString(remainingSeconds))
                        .font(.system(size: 56, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()

                    Text(isRunning ? "進行中" : "準備好後按『開始』")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.75))
                }

                Spacer()

                // 底部按鈕
                HStack(spacing: 12) {
                    if !isRunning {
                        Button(action: startTimer) {
                            Text("開始")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "BA7517"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }

                    Button(action: completeStep) {
                        Text(currentStepIndex == steps.count - 1 ? "完成" : "下一步")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.black.opacity(0.25))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            remainingSeconds = currentStep.durationSeconds
        }
        .onDisappear {
            stopTimer()
        }
    }

    // MARK: - 控制

    private func startTimer() {
        isRunning = true
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                stopTimer()
                // 時間到自動進入下一步
                completeStep()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func completeStep() {
        stopTimer()
        UINotificationFeedbackGenerator().notificationOccurred(.success)

        if currentStepIndex < steps.count - 1 {
            // 下一步
            withAnimation(.spring(response: 0.4)) {
                currentStepIndex += 1
                remainingSeconds = steps[currentStepIndex].durationSeconds
            }
        } else {
            // 走完了
            onComplete()
        }
    }

    private func timeString(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

#Preview {
    PipelineView(isPresented: .constant(true), onComplete: {})
}
