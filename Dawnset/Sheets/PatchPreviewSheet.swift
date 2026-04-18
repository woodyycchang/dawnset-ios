import SwiftUI

struct PatchPreviewSheet: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.gapL) {

                    inputCard

                    if state.pendingPatches.isEmpty {
                        emptyState
                    } else {
                        patchesSection
                    }
                }
                .padding(DS.screenPadding)
            }
            .navigationTitle("AI 建議")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") {
                        state.cancelPendingPatches()
                        state.activeSheet = nil
                    }
                    .font(.system(size: DS.body))
                }

                if !state.pendingPatches.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { state.acceptPendingPatches() }) {
                            Text("全部接受")
                                .font(.system(size: DS.body, weight: .semibold))
                                .foregroundStyle(Color(hex: "#0F6E56"))
                        }
                    }
                }
            }
        }
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: DS.gapS) {
            Text("你的話")
                .font(.system(size: DS.label, weight: .medium))
                .foregroundStyle(.secondary)
                .tracking(0.5)

            Text("「\(state.lastAIInput)」")
                .font(.system(size: DS.body))
                .lineSpacing(DS.lineBody)
                .foregroundStyle(.primary)
        }
        .padding(DS.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#F5F4EF"))
        .cornerRadius(DS.radiusMedium)
    }

    private var emptyState: some View {
        VStack(spacing: DS.gap) {
            Text("AI 沒提出建議")
                .font(.system(size: DS.body, weight: .medium))

            Text("試著提供更具體的資訊，例如時間限制、過敏、偏好。")
                .font(.system(size: DS.bodyS))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(DS.lineBody)
                .padding(.horizontal, DS.gap)
        }
        .padding(DS.gapXL)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(DS.radiusCard)
    }

    private var patchesSection: some View {
        VStack(alignment: .leading, spacing: DS.gapM) {
            Text("AI 建議 \(state.pendingPatches.count) 個調整")
                .font(.system(size: DS.label, weight: .medium))
                .foregroundStyle(.secondary)
                .tracking(0.5)

            VStack(spacing: DS.gap) {
                ForEach(state.pendingPatches) { patch in
                    patchCard(patch: patch)
                }
            }
        }
    }

    @ViewBuilder
    private func patchCard(patch: AIPatch) -> some View {
        VStack(alignment: .leading, spacing: DS.gapS) {
            HStack(spacing: DS.gapS) {
                Image(systemName: iconFor(kind: patch.kind))
                    .font(.system(size: DS.bodyS, weight: .semibold))
                    .foregroundStyle(colorFor(kind: patch.kind))
                    .frame(width: 24, height: 24)
                    .background(colorFor(kind: patch.kind).opacity(0.1))
                    .clipShape(Circle())

                Text(labelFor(kind: patch.kind))
                    .font(.system(size: DS.label, weight: .semibold))
                    .foregroundStyle(colorFor(kind: patch.kind))
                    .tracking(0.5)

                Spacer()

                Text(patch.pipelineType.displayName)
                    .font(.system(size: DS.caption, weight: .medium))
                    .foregroundStyle(patch.pipelineType.accentColor)
                    .padding(.horizontal, DS.gapS)
                    .padding(.vertical, 3)
                    .background(patch.pipelineType.accentColor.opacity(0.12))
                    .cornerRadius(DS.radiusChip)
            }

            Text(summary(for: patch.kind))
                .font(.system(size: DS.body, weight: .medium))
                .lineSpacing(DS.lineBody)

            if !patch.reason.isEmpty {
                Text(patch.reason)
                    .font(.system(size: DS.bodyS))
                    .foregroundStyle(.secondary)
                    .lineSpacing(DS.lineBody)
                    .padding(.top, DS.gapXS)
            }
        }
        .padding(DS.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(DS.radiusCard)
    }

    // MARK: - Describe the patch kind

    private func iconFor(kind: AIPatchKind) -> String {
        switch kind {
        case .add:    return "plus"
        case .remove: return "minus"
        case .modify: return "pencil"
        case .adjust: return "slider.horizontal.3"
        }
    }

    private func colorFor(kind: AIPatchKind) -> Color {
        switch kind {
        case .add:    return Color(hex: "#0F6E56")
        case .remove: return Color(hex: "#E24B4A")
        case .modify: return Color(hex: "#BA7517")
        case .adjust: return Color(hex: "#378ADD")
        }
    }

    private func labelFor(kind: AIPatchKind) -> String {
        switch kind {
        case .add:    return "新增"
        case .remove: return "移除"
        case .modify: return "修改"
        case .adjust: return "調整時間"
        }
    }

    /// Human-readable description of what the patch will do.
    private func summary(for kind: AIPatchKind) -> String {
        switch kind {
        case .add(_, let step):
            return "加入「\(step.act)」"
        case .modify(let stepId, let newAct):
            if let existing = findStep(id: stepId) {
                return "把「\(existing.act)」改成「\(newAct)」"
            }
            return "改為「\(newAct)」"
        case .adjust(let stepId, let newMinutes):
            let timeStr: String
            if let m = newMinutes {
                if m < 1 {
                    timeStr = "\(Int(m * 60)) 秒"
                } else if m == m.rounded() {
                    timeStr = "\(Int(m)) 分"
                } else {
                    timeStr = String(format: "%.1f 分", m)
                }
            } else {
                timeStr = "不設時間"
            }
            if let existing = findStep(id: stepId) {
                return "「\(existing.act)」時間改為 \(timeStr)"
            }
            return "時間改為 \(timeStr)"
        case .remove(let stepId):
            if let existing = findStep(id: stepId) {
                return "移除「\(existing.act)」"
            }
            return "移除一個步驟"
        }
    }

    /// Find an existing step by id across all pipelines.
    private func findStep(id: String) -> PipelineStep? {
        for type in PipelineType.allCases {
            if let step = state.stepsFor(type).first(where: { $0.id == id }) {
                return step
            }
        }
        return nil
    }
}
