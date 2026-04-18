import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#1C3A5A"), Color(hex: "#5A84B3")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: DS.gapL) {
                Spacer()

                VStack(alignment: .leading, spacing: DS.gap) {
                    Text("Dawnset")
                        .font(.system(size: DS.bodyS, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                        .tracking(1.5)

                    Text("不用自己想。")
                        .font(.system(size: DS.titleXL, weight: .medium))
                        .foregroundStyle(.white)
                        .lineSpacing(DS.lineTitle)

                    Text("跟著做就好。")
                        .font(.system(size: DS.titleXL, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                        .lineSpacing(DS.lineTitle)
                }

                VStack(alignment: .leading, spacing: DS.gap) {
                    bullet("每天一條照顧自己的 pipeline")
                    bullet("AI 幫你改，不用手動調")
                    bullet("研究為基礎，不是 vibes")
                }
                .padding(.top, DS.gapL)

                Spacer()

                Button(action: { state.completeOnboarding() }) {
                    Text("開始")
                        .font(.system(size: DS.body, weight: .semibold))
                        .foregroundStyle(Color(hex: "#1C3A5A"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(DS.radiusButton)
                }
                .buttonStyle(.pressablePrimary)
            }
            .padding(.horizontal, DS.screenPadding)
            .padding(.bottom, DS.bottomSafe)
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: DS.gap) {
            Circle()
                .fill(Color.white.opacity(0.55))
                .frame(width: 6, height: 6)
                .padding(.top, 9)

            Text(text)
                .font(.system(size: DS.body))
                .foregroundStyle(.white.opacity(0.9))
                .lineSpacing(DS.lineBody)
        }
    }
}
