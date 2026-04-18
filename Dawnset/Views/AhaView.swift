import SwiftUI

struct AhaView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0F6E56"), Color(hex: "#5FB09A")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: DS.gapL) {
                Spacer()

                CheckCircle()
                    .shadow(color: .black.opacity(0.1), radius: 20, y: 6)

                VStack(spacing: DS.gapS) {
                    Text(titleText)
                        .font(.system(size: DS.titleL, weight: .medium))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("繼續做一點有用的事")
                        .font(.system(size: DS.body))
                        .foregroundStyle(.white.opacity(0.9))
                }

                scoreBlock
                    .padding(.top, DS.gap)

                Spacer()

                actionButtons
            }
            .padding(.horizontal, DS.screenPadding)
            .padding(.bottom, DS.bottomSafe)
        }
    }

    private var titleText: String {
        guard let type = state.runningType else {
            return "做完了"
        }
        switch type {
        case .morning:   return "早上一切必要的都完成了"
        case .workStart: return "準備好進入深度工作"
        case .afternoon: return "下半天的重整完成"
        case .bedtime:   return "今天可以放下了"
        }
    }

    private var scoreBlock: some View {
        VStack(spacing: DS.gapXS) {
            Text("影響分數")
                .font(.system(size: DS.label))
                .foregroundStyle(.white.opacity(0.85))
                .tracking(0.5)

            Text("+\(state.todayScore)")
                .font(.system(size: DS.display + 8, weight: .medium))
                .foregroundStyle(.white)
                .tracking(-1)

            if state.historicalAverageScore > 0 {
                Text("你的平均：\(state.historicalAverageScore)")
                    .font(.system(size: DS.label))
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.top, DS.gapXS)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: DS.gap) {
            Button(action: { state.leaveAha() }) {
                Text("出發")
                    .font(.system(size: DS.body, weight: .semibold))
                    .foregroundStyle(Color(hex: "#0F6E56"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(DS.radiusButton)
            }
            .buttonStyle(.pressablePrimary)

            Button(action: { state.undoCompletion() }) {
                Text("回到上一步")
                    .font(.system(size: DS.bodyS, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DS.gap)
            }
            .buttonStyle(.pressable)
        }
    }
}
