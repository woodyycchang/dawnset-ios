import SwiftUI

struct PipelineRunView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ZStack {
            Color(hex: "#FBF9F4").ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                progressDots
                    .padding(.top, DS.gapM)
                    .padding(.bottom, DS.gapL)

                Spacer()

                if let step = currentStep {
                    stepContent(step: step)
                }

                Spacer()

                bottomActions
                    .padding(.bottom, DS.bottomSafe)
            }
            .padding(.horizontal, DS.screenPadding)
        }
    }

    private var currentStep: PipelineStep? {
        guard state.currentStepIdx < state.runningSteps.count else { return nil }
        return state.runningSteps[state.currentStepIdx]
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            Button(action: { state.pausePipeline() }) {
                HStack(spacing: DS.gapXS) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: DS.bodyS, weight: .medium))
                    Text("暫停")
                        .font(.system(size: DS.bodyS, weight: .medium))
                }
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.pressable)

            Spacer()

            if let type = state.runningType {
                Text(type.displayName)
                    .font(.system(size: DS.bodyS, weight: .medium))
                    .foregroundStyle(type.accentColor)
            }

            Spacer()

            Button(action: { state.undoLastStep() }) {
                Text("↶ 上一步")
                    .font(.system(size: DS.bodyS, weight: .medium))
                    .foregroundStyle(.secondary)
                    .opacity(state.stepHistory.isEmpty ? 0.3 : 1)
            }
            .buttonStyle(.pressable)
            .disabled(state.stepHistory.isEmpty)
        }
        .padding(.top, DS.gapM)
    }

    // MARK: - Progress dots

    private var progressDots: some View {
        HStack(spacing: DS.gapS) {
            ForEach(Array(state.runningSteps.enumerated()), id: \.offset) { idx, _ in
                dot(for: idx)
            }
        }
    }

    @ViewBuilder
    private func dot(for idx: Int) -> some View {
        let isCurrent = idx == state.currentStepIdx
        let s = state.stepStates[safe: idx] ?? nil

        Button(action: { state.jumpToStep(idx) }) {
            RoundedRectangle(cornerRadius: 3)
                .fill(dotColor(state: s, isCurrent: isCurrent))
                .frame(width: isCurrent ? 20 : 8, height: 6)
        }
        .buttonStyle(.pressableQuiet)
    }

    private func dotColor(state: StepCompletionState?, isCurrent: Bool) -> Color {
        if state == .done { return Color(hex: "#0F6E56") }
        if state == .skipped { return Color(hex: "#BA7517").opacity(0.4) }
        if isCurrent { return Color(hex: "#2D2D2D") }
        return Color(hex: "#D9D7D2")
    }

    // MARK: - Step content

    @ViewBuilder
    private func stepContent(step: PipelineStep) -> some View {
        VStack(alignment: .leading, spacing: DS.gap) {
            Text("第 \(state.currentStepIdx + 1) 步 / \(state.runningSteps.count)")
                .font(.system(size: DS.label, weight: .medium))
                .foregroundStyle(.secondary)
                .tracking(0.5)

            Text(step.act)
                .font(.system(size: DS.titleL, weight: .medium))
                .lineSpacing(DS.lineTitle)

            HStack(spacing: DS.gapS) {
                if step.minutes != nil {
                    label("⏱ \(step.minuteString)")
                }
                label(step.pillar.displayName, color: Color(hex: "#BA7517"))

                if let key = step.citationKey, !key.isEmpty {
                    Button(action: {
                        state.activeSheet = .citation(key: key)
                    }) {
                        Text("研究")
                            .font(.system(size: DS.caption, weight: .medium))
                            .foregroundStyle(Color(hex: "#0F6E56"))
                            .padding(.horizontal, DS.gapS)
                            .padding(.vertical, DS.gapXS + 1)
                            .background(Color(hex: "#0F6E56").opacity(0.1))
                            .cornerRadius(DS.radiusChip)
                    }
                    .buttonStyle(.pressable)
                }

                if state.isCustom(step.id) {
                    label("✦ AI 調整", color: Color(hex: "#378ADD"))
                }
            }
            .padding(.top, DS.gapXS)
        }
        .padding(DS.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(DS.radiusCard)
    }

    private func label(_ text: String, color: Color = .secondary) -> some View {
        Text(text)
            .font(.system(size: DS.caption, weight: .medium))
            .foregroundStyle(color)
            .padding(.horizontal, DS.gapS)
            .padding(.vertical, DS.gapXS + 1)
            .background(color.opacity(0.1))
            .cornerRadius(DS.radiusChip)
    }

    // MARK: - Bottom actions

    private var bottomActions: some View {
        VStack(spacing: DS.gap) {
            Button(action: { state.markCurrentStepDone() }) {
                Text("做完 · 下一步")
                    .font(.system(size: DS.body, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "#0F6E56"))
                    .cornerRadius(DS.radiusButton)
            }
            .buttonStyle(.pressablePrimary)

            Button(action: { state.markCurrentStepSkipped() }) {
                Text("略過")
                    .font(.system(size: DS.bodyS, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DS.gap)
            }
            .buttonStyle(.pressable)
        }
    }
}

// Safe subscript helper
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
