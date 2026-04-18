import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        Group {
            switch state.currentRecommendation {
            case .allDone:
                allDoneView
            case .empty(let reason):
                emptyStateView(reason: reason)
            case .pipeline(let type, let reason):
                recommendedView(type: type, reason: reason)
            }
        }
    }

    // MARK: - Recommended pipeline

    @ViewBuilder
    private func recommendedView(type: PipelineType, reason: String) -> some View {
        ZStack {
            type.gradient.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                headerDate
                    .padding(.top, DS.gapL)

                Spacer()

                if let paused = state.pausedPipeline, paused.type == type {
                    pausedCard(paused: paused, type: type)
                } else {
                    startCard(type: type, reason: reason)
                }

                if state.todayScore > 0 {
                    Text("今天影響分數 \(state.todayScore)")
                        .font(.system(size: DS.bodyS, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.top, DS.gapM)
                }

                Spacer()

                footerButtons
            }
            .padding(.horizontal, DS.screenPadding)
            .padding(.bottom, DS.bottomSafe)
        }
    }

    // MARK: - All done

    private var allDoneView: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0F6E56"), Color(hex: "#E1F5EE")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: DS.gap) {
                Spacer()

                CheckCircle()

                Text("今天都做完了")
                    .font(.system(size: DS.titleL, weight: .medium))
                    .foregroundStyle(.white)

                Text("晚安。明天再見。")
                    .font(.system(size: DS.body))
                    .foregroundStyle(.white.opacity(0.92))

                VStack(spacing: DS.gapXS) {
                    Text("今天總分")
                        .font(.system(size: DS.label))
                        .foregroundStyle(.white.opacity(0.85))
                    Text("+\(state.todayScore)")
                        .font(.system(size: DS.display, weight: .medium))
                        .foregroundStyle(.white)
                        .tracking(-1)
                }
                .padding(.top, DS.gapM)

                Spacer()

                VStack(spacing: DS.gapS) {
                    Button(action: { state.activeSheet = .agent }) {
                        Text("✦ 告訴 AI 明天想調整什麼")
                            .font(.system(size: DS.body, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.white.opacity(0.22))
                            .overlay(
                                RoundedRectangle(cornerRadius: DS.radiusButton)
                                    .stroke(.white.opacity(0.4), lineWidth: 1)
                            )
                            .cornerRadius(DS.radiusButton)
                    }
                    .buttonStyle(.pressable)

                    Button(action: { state.activeSheet = .manualPicker }) {
                        Text("再跑一次某個 pipeline")
                            .font(.system(size: DS.bodyS, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.pressable)

                    Button(action: { state.screen = .impact }) {
                        Text("看累積影響")
                            .font(.system(size: DS.bodyS, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.pressable)

                    HStack {
                        Spacer()
                        Button(action: { state.activeSheet = .settings }) {
                            Image(systemName: "gearshape")
                                .font(.system(size: DS.body))
                                .foregroundStyle(.white.opacity(0.85))
                        }
                        .buttonStyle(.pressable)
                    }
                    .padding(.top, DS.gapXS)
                }
            }
            .padding(.horizontal, DS.screenPadding)
            .padding(.bottom, DS.bottomSafe)
        }
    }

    // MARK: - Empty state

    @ViewBuilder
    private func emptyStateView(reason: String) -> some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: DS.gapL) {
                HStack {
                    Spacer()
                    Button(action: { state.activeSheet = .settings }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: DS.body))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.pressable)
                }
                .padding(.top, DS.gapS)

                Spacer()

                Text("現在")
                    .font(.system(size: DS.label))
                    .foregroundStyle(.secondary)

                Text("\(reason)。")
                    .font(.system(size: DS.titleL, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineSpacing(DS.lineTitle)

                Text("回去做你真正想做的事。")
                    .font(.system(size: DS.body))
                    .foregroundStyle(.secondary)
                    .lineSpacing(DS.lineBody)

                Spacer()

                Button(action: { state.activeSheet = .manualPicker }) {
                    Text("手動選一個 pipeline")
                        .font(.system(size: DS.body, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#F5F4EF"))
                        .cornerRadius(DS.radiusButton)
                }
                .buttonStyle(.pressable)
                .padding(.bottom, DS.gapS)

                Button(action: { state.screen = .lowEnergy }) {
                    Text("今天有點不想動？")
                        .font(.system(size: DS.bodyS))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.pressable)
            }
            .padding(.horizontal, DS.screenPadding)
            .padding(.bottom, DS.bottomSafe)
        }
    }

    // MARK: - Reusable pieces

    private var headerDate: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: DS.gapXS) {
                Text(formattedDate())
                    .font(.system(size: DS.label))
                    .foregroundStyle(.white.opacity(0.85))
                Text(formattedClock())
                    .font(.system(size: DS.display, weight: .medium))
                    .foregroundStyle(.white)
                    .tracking(-1)
            }

            Spacer()

            Button(action: { state.activeSheet = .settings }) {
                Image(systemName: "gearshape")
                    .font(.system(size: DS.body))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(DS.gapS)
            }
            .buttonStyle(.pressable)
        }
    }

    @ViewBuilder
    private func startCard(type: PipelineType, reason: String) -> some View {
        let steps = state.stepsFor(type)
        let hasCustom = steps.contains { state.isCustom($0.id) }

        VStack(alignment: .leading, spacing: DS.gapS) {
            HStack(spacing: DS.gapXS) {
                Text("Dawnset ・ \(type.displayName)")
                    .font(.system(size: DS.bodyS, weight: .medium))
                    .foregroundStyle(type.accentColor)

                if hasCustom {
                    Circle()
                        .fill(type.accentColor)
                        .frame(width: 6, height: 6)
                }
            }

            Text("開始 \(type.displayName)")
                .font(.system(size: DS.titleM, weight: .medium))

            Text("\(steps.count) 步・約 \(minuteString(state.totalMinutes(for: type)))・\(reason)")
                .font(.system(size: DS.label))
                .foregroundStyle(.secondary)
                .lineSpacing(DS.lineCaption)

            Button(action: { state.startPipeline(type) }) {
                Text("開始")
                    .font(.system(size: DS.body, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(type.accentColor)
                    .cornerRadius(DS.radiusButton)
            }
            .buttonStyle(.pressablePrimary)
            .padding(.top, DS.gapS)
        }
        .padding(DS.cardPadding)
        .background(Color.white)
        .cornerRadius(DS.radiusCard)
    }

    @ViewBuilder
    private func pausedCard(paused: PausedPipelineState, type: PipelineType) -> some View {
        VStack(alignment: .leading, spacing: DS.gapS) {
            Text("繼續上次 · \(type.displayName)")
                .font(.system(size: DS.bodyS, weight: .medium))
                .foregroundStyle(type.accentColor)

            Text("做到第 \(paused.stepIndex + 1) 步")
                .font(.system(size: DS.titleM, weight: .medium))

            HStack(spacing: DS.gapS) {
                Button(action: { state.resumePausedPipeline() }) {
                    Text("繼續")
                        .font(.system(size: DS.body, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(type.accentColor)
                        .cornerRadius(DS.radiusButton)
                }
                .buttonStyle(.pressablePrimary)
                .frame(maxWidth: .infinity)

                Button(action: { state.discardPaused() }) {
                    Text("重開")
                        .font(.system(size: DS.bodyS))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: 90)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#F5F4EF"))
                        .cornerRadius(DS.radiusButton)
                }
                .buttonStyle(.pressable)
            }
            .padding(.top, DS.gapXS)
        }
        .padding(DS.cardPadding)
        .background(Color.white)
        .cornerRadius(DS.radiusCard)
    }

    private var footerButtons: some View {
        HStack(spacing: DS.gapS) {
            Button(action: { state.activeSheet = .agent }) {
                Text("✦ 調整 pipeline")
                    .font(.system(size: DS.label, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, DS.gap)
                    .padding(.vertical, DS.gapS)
                    .background(.white.opacity(0.22))
                    .cornerRadius(DS.radiusChip + 6)
            }
            .buttonStyle(.pressable)

            Button("選其他") { state.activeSheet = .manualPicker }
                .font(.system(size: DS.label))
                .foregroundStyle(.white.opacity(0.85))
                .buttonStyle(.pressable)

            Button("不想動") { state.screen = .lowEnergy }
                .font(.system(size: DS.label))
                .foregroundStyle(.white.opacity(0.85))
                .buttonStyle(.pressable)

            Button("影響") { state.screen = .impact }
                .font(.system(size: DS.label))
                .foregroundStyle(.white.opacity(0.85))
                .buttonStyle(.pressable)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Helpers

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_Hant")
        f.dateFormat = "EEEE・M 月 d 日"
        return f.string(from: Date())
    }

    private func formattedClock() -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: Date())
    }

    private func minuteString(_ total: Double) -> String {
        if total < 1 { return "\(Int(total * 60)) 秒" }
        if total == total.rounded() { return "\(Int(total)) 分" }
        return String(format: "%.1f 分", total)
    }
}

struct CheckCircle: View {
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 72, height: 72)
            .overlay(
                Image(systemName: "checkmark")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color(hex: "#0F6E56"))
            )
    }
}
