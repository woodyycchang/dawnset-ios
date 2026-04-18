import SwiftUI

struct AgentSheet: View {
    @EnvironmentObject private var state: AppState
    @State private var input: String = ""
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.gapL) {
                    VStack(alignment: .leading, spacing: DS.gap) {
                        Text("告訴 AI 你想怎麼調整")
                            .font(.system(size: DS.titleM, weight: .medium))

                        Text("例如「我對咖啡因敏感」「晚上沒時間做瑜珈」「早上想多睡 5 分鐘」")
                            .font(.system(size: DS.bodyS))
                            .foregroundStyle(.secondary)
                            .lineSpacing(DS.lineCaption)
                    }

                    ZStack(alignment: .topLeading) {
                        if input.isEmpty {
                            Text("告訴 AI…")
                                .font(.system(size: DS.body))
                                .foregroundStyle(.secondary.opacity(0.5))
                                .padding(.top, 14)
                                .padding(.leading, DS.gapM)
                        }

                        TextEditor(text: $input)
                            .font(.system(size: DS.body))
                            .lineSpacing(DS.lineBody)
                            .focused($focused)
                            .scrollContentBackground(.hidden)
                            .padding(DS.gapS)
                            .frame(minHeight: 160)
                    }
                    .background(Color(hex: "#F5F4EF"))
                    .cornerRadius(DS.radiusMedium)

                    Button(action: {
                        guard !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        state.runAIWithInput(input)
                        state.activeSheet = .patchPreview
                    }) {
                        Text("產生建議")
                            .font(.system(size: DS.body, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#0F6E56"))
                            .cornerRadius(DS.radiusButton)
                    }
                    .buttonStyle(.pressablePrimary)
                    .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
                }
                .padding(DS.screenPadding)
            }
            .navigationTitle("調整 pipeline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") {
                        state.activeSheet = nil
                    }
                    .font(.system(size: DS.body))
                }
            }
        }
        .onAppear { focused = true }
    }
}
