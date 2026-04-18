import SwiftUI

struct LowEnergyView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#6A4C8C"), Color(hex: "#B8A4CF")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: DS.gapL) {
                topBar

                Spacer()

                VStack(alignment: .leading, spacing: DS.gap) {
                    Text("今天不想動")
                        .font(.system(size: DS.titleL, weight: .medium))
                        .foregroundStyle(.white)

                    Text("這些都算做到，選一個能做的。")
                        .font(.system(size: DS.body))
                        .foregroundStyle(.white.opacity(0.9))
                        .lineSpacing(DS.lineBody)
                }

                VStack(spacing: DS.gap) {
                    option("喝一杯水", icon: "drop.fill")
                    option("站起來拉伸 1 分鐘", icon: "figure.walk")
                    option("走 5 步", icon: "shoe.2")
                    option("打開窗戶透氣", icon: "wind")
                }
                .padding(.top, DS.gapM)

                Spacer()

                Button(action: { state.screen = .home }) {
                    Text("回主畫面")
                        .font(.system(size: DS.bodyS, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.gap)
                }
                .buttonStyle(.pressable)
            }
            .padding(.horizontal, DS.screenPadding)
            .padding(.bottom, DS.bottomSafe)
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: { state.screen = .home }) {
                HStack(spacing: DS.gapXS) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: DS.bodyS, weight: .medium))
                    Text("回去")
                        .font(.system(size: DS.bodyS, weight: .medium))
                }
                .foregroundStyle(.white.opacity(0.9))
            }
            .buttonStyle(.pressable)

            Spacer()
        }
        .padding(.top, DS.gapM)
    }

    @ViewBuilder
    private func option(_ title: String, icon: String) -> some View {
        Button(action: {
            state.recordLowEnergyAction()
            state.screen = .home
        }) {
            HStack(spacing: DS.gap) {
                Image(systemName: icon)
                    .font(.system(size: DS.titleS))
                    .foregroundStyle(Color(hex: "#6A4C8C"))
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())

                Text(title)
                    .font(.system(size: DS.body, weight: .medium))
                    .foregroundStyle(Color(hex: "#2D2D2D"))

                Spacer()

                Text("+2")
                    .font(.system(size: DS.bodyS, weight: .semibold))
                    .foregroundStyle(Color(hex: "#6A4C8C"))
            }
            .padding(DS.gapM)
            .background(Color.white.opacity(0.92))
            .cornerRadius(DS.radiusMedium)
        }
        .buttonStyle(.pressable)
    }
}
