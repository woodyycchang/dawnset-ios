import SwiftUI

struct SettingsSheet: View {
    @EnvironmentObject private var state: AppState
    @State private var currentLevel: HapticLevel = HapticPreference.level

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    sectionHeader("震動回饋")
                        .padding(.top, DS.gapS)

                    VStack(spacing: 0) {
                        ForEach(HapticLevel.allCases) { level in
                            hapticOption(level: level)
                            if level != HapticLevel.allCases.last {
                                Divider().padding(.leading, DS.gapM)
                            }
                        }
                    }
                    .background(Color(hex: "#F5F4EF"))
                    .cornerRadius(DS.radiusMedium)

                    Text("依照 Apple HIG 與 JMIR 2023 研究建議，提供三段控制。預設「完整」；若你覺得震動太頻繁，改「最小」。")
                        .font(.system(size: DS.caption))
                        .foregroundStyle(.secondary)
                        .lineSpacing(DS.lineCaption)
                        .padding(.top, DS.gap)
                        .padding(.horizontal, DS.gapS)

                    sectionHeader("關於")
                        .padding(.top, DS.gapXL)

                    VStack(alignment: .leading, spacing: DS.gapS) {
                        infoRow(label: "版本", value: "v1.0")
                        Divider()
                        infoRow(label: "完成記錄", value: "\(state.history.count) 次")
                        Divider()
                        infoRow(label: "AI 客製步驟", value: "\(state.customIds.count) 個")
                    }
                    .padding(.horizontal, DS.gapM)
                    .padding(.vertical, DS.gap)
                    .background(Color(hex: "#F5F4EF"))
                    .cornerRadius(DS.radiusMedium)

                    sectionHeader("進階")
                        .padding(.top, DS.gapXL)

                    Button(action: {
                        state.resetAllCustomizations()
                    }) {
                        Text("還原所有 AI 客製到原廠")
                            .font(.system(size: DS.bodyS, weight: .medium))
                            .foregroundStyle(Color(hex: "#E24B4A"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .overlay(
                                RoundedRectangle(cornerRadius: DS.radiusButton)
                                    .stroke(Color(hex: "#E24B4A").opacity(0.3), lineWidth: 0.5)
                            )
                    }
                    .buttonStyle(.pressable)
                    .padding(.bottom, DS.gapL)
                }
                .padding(.horizontal, DS.screenPadding)
                .padding(.vertical, DS.gapS)
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { state.activeSheet = nil }
                        .font(.system(size: DS.body))
                }
            }
        }
        .presentationDetents([.large])
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: DS.label, weight: .medium))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(0.5)
            .padding(.horizontal, DS.gapS)
            .padding(.bottom, DS.gapS)
    }

    @ViewBuilder
    private func hapticOption(level: HapticLevel) -> some View {
        Button(action: {
            HapticPreference.level = level
            currentLevel = level
            switch level {
            case .full:    Haptics.tadaa()
            case .minimal: Haptics.click()
            case .off:     break
            }
        }) {
            HStack(spacing: DS.gap) {
                Image(systemName: currentLevel == level ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: DS.titleS))
                    .foregroundStyle(currentLevel == level ? Color(hex: "#0F6E56") : .secondary.opacity(0.4))

                VStack(alignment: .leading, spacing: DS.gapXS) {
                    Text(level.displayName)
                        .font(.system(size: DS.body, weight: .medium))
                        .foregroundStyle(.primary)

                    Text(level.description)
                        .font(.system(size: DS.caption))
                        .foregroundStyle(.secondary)
                        .lineSpacing(DS.lineCaption)
                }

                Spacer()
            }
            .padding(.horizontal, DS.gapM)
            .padding(.vertical, DS.gap)
            .contentShape(Rectangle())
        }
        .buttonStyle(.pressableQuiet)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: DS.bodyS))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: DS.bodyS, weight: .medium))
        }
        .padding(.vertical, DS.gapXS)
    }
}
