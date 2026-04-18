import SwiftUI

struct ImpactView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ZStack {
            Color(hex: "#FBF9F4").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: DS.gapL) {
                    topBar

                    header

                    summaryCard

                    historyList

                    Spacer(minLength: DS.bottomSafe)
                }
                .padding(.horizontal, DS.screenPadding)
                .padding(.bottom, DS.bottomSafe)
            }
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
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.pressable)

            Spacer()
        }
        .padding(.top, DS.gapM)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DS.gapS) {
            Text("影響")
                .font(.system(size: DS.titleL, weight: .medium))

            Text("你照顧自己身體的累積。")
                .font(.system(size: DS.body))
                .foregroundStyle(.secondary)
                .lineSpacing(DS.lineBody)
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: DS.gapM) {
            Text("總計")
                .font(.system(size: DS.label, weight: .medium))
                .foregroundStyle(.secondary)
                .tracking(0.5)

            HStack(alignment: .firstTextBaseline, spacing: DS.gapM) {
                VStack(alignment: .leading, spacing: DS.gapXS) {
                    Text("\(totalScore)")
                        .font(.system(size: DS.display, weight: .medium))
                        .foregroundStyle(Color(hex: "#0F6E56"))
                        .tracking(-1)
                    Text("分")
                        .font(.system(size: DS.bodyS))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: DS.gapXS) {
                    Text("\(state.history.count)")
                        .font(.system(size: DS.titleL, weight: .medium))
                        .foregroundStyle(Color(hex: "#2D2D2D"))
                    Text("次完成")
                        .font(.system(size: DS.bodyS))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(DS.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(DS.radiusCard)
    }

    private var historyList: some View {
        VStack(alignment: .leading, spacing: DS.gap) {
            Text("最近")
                .font(.system(size: DS.label, weight: .medium))
                .foregroundStyle(.secondary)
                .tracking(0.5)
                .padding(.horizontal, DS.gapXS)

            if state.history.isEmpty {
                VStack(spacing: DS.gapS) {
                    Text("還沒完成過任何 pipeline")
                        .font(.system(size: DS.bodyS))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.gapXL)
                }
                .background(Color.white)
                .cornerRadius(DS.radiusCard)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(state.history.reversed().prefix(10).enumerated()), id: \.offset) { idx, record in
                        historyRow(record: record)
                        if idx < min(9, state.history.count - 1) {
                            Divider().padding(.leading, DS.cardPadding)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(DS.radiusCard)
            }
        }
    }

    @ViewBuilder
    private func historyRow(record: CompletionRecord) -> some View {
        HStack(spacing: DS.gap) {
            Circle()
                .fill(record.type.accentColor)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.type.displayName)
                    .font(.system(size: DS.body, weight: .medium))
                Text(dateString(record.completedAt))
                    .font(.system(size: DS.caption))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("+\(record.score)")
                .font(.system(size: DS.body, weight: .semibold))
                .foregroundStyle(Color(hex: "#0F6E56"))
        }
        .padding(DS.cardPadding)
    }

    private var totalScore: Int {
        state.history.reduce(0) { $0 + $1.score }
    }

    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_Hant")
        f.dateFormat = "M/d HH:mm"
        return f.string(from: date)
    }
}
