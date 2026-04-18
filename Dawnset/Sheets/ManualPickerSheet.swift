import SwiftUI

struct ManualPickerSheet: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DS.gap) {
                    ForEach(PipelineType.allCases, id: \.self) { type in
                        pipelineCard(type: type)
                    }
                }
                .padding(DS.screenPadding)
            }
            .navigationTitle("選 pipeline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") { state.activeSheet = nil }
                        .font(.system(size: DS.body))
                }
            }
        }
    }

    @ViewBuilder
    private func pipelineCard(type: PipelineType) -> some View {
        let steps = state.stepsFor(type)
        let minutes = state.totalMinutes(for: type)
        let isCompleted = state.completed[type] ?? false
        let hasCustom = steps.contains { state.isCustom($0.id) }

        Button(action: { state.manualStart(type) }) {
            VStack(alignment: .leading, spacing: DS.gap) {
                HStack(alignment: .center, spacing: DS.gapS) {
                    Text(type.displayName)
                        .font(.system(size: DS.titleM, weight: .medium))
                        .foregroundStyle(type.accentColor)

                    if hasCustom {
                        Circle()
                            .fill(type.accentColor)
                            .frame(width: 7, height: 7)
                    }

                    Spacer()

                    if isCompleted {
                        HStack(spacing: DS.gapXS) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: DS.bodyS))
                            Text("今天已完成")
                                .font(.system(size: DS.caption, weight: .medium))
                        }
                        .foregroundStyle(Color(hex: "#0F6E56"))
                    }
                }

                Text("\(steps.count) 步・約 \(minuteString(minutes))")
                    .font(.system(size: DS.bodyS))
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: DS.gapXS) {
                    ForEach(steps.prefix(3), id: \.id) { step in
                        HStack(spacing: DS.gapS) {
                            Circle()
                                .fill(.secondary.opacity(0.4))
                                .frame(width: 4, height: 4)
                            Text(step.act)
                                .font(.system(size: DS.label))
                                .foregroundStyle(.secondary)
                        }
                    }
                    if steps.count > 3 {
                        Text("… 還有 \(steps.count - 3) 步")
                            .font(.system(size: DS.caption))
                            .foregroundStyle(.secondary.opacity(0.7))
                            .padding(.leading, 12)
                    }
                }
                .padding(.top, DS.gapXS)
            }
            .padding(DS.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(DS.radiusCard)
        }
        .buttonStyle(.pressable)
    }

    private func minuteString(_ total: Double) -> String {
        if total < 1 { return "\(Int(total * 60)) 秒" }
        if total == total.rounded() { return "\(Int(total)) 分" }
        return String(format: "%.1f 分", total)
    }
}
