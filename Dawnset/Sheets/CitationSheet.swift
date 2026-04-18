import SwiftUI

struct CitationSheet: View {
    @EnvironmentObject private var state: AppState
    let citationKey: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.gapL) {
                    if let citation = Citations.all[citationKey] {
                        citationCard(citation: citation)
                    } else {
                        Text("找不到這篇研究")
                            .font(.system(size: DS.body))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(DS.screenPadding)
            }
            .navigationTitle("研究")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { state.activeSheet = nil }
                        .font(.system(size: DS.body))
                }
            }
        }
    }

    @ViewBuilder
    private func citationCard(citation: Citation) -> some View {
        VStack(alignment: .leading, spacing: DS.gap) {
            HStack {
                Text(citation.level.displayName)
                    .font(.system(size: DS.caption, weight: .semibold))
                    .foregroundStyle(citation.level.color)
                    .tracking(0.5)
                    .padding(.horizontal, DS.gapS)
                    .padding(.vertical, DS.gapXS)
                    .background(citation.level.color.opacity(0.1))
                    .cornerRadius(DS.radiusChip)

                Spacer()
            }

            Text(citation.title)
                .font(.system(size: DS.titleM, weight: .medium))
                .lineSpacing(DS.lineTitle)

            Text("— \(citation.authors)")
                .font(.system(size: DS.bodyS))
                .foregroundStyle(.secondary)

            Text(citation.venue)
                .font(.system(size: DS.bodyS))
                .foregroundStyle(.secondary.opacity(0.85))
                .italic()

            Divider()
                .padding(.vertical, DS.gapS)

            VStack(alignment: .leading, spacing: DS.gapS) {
                Text("主要發現")
                    .font(.system(size: DS.label, weight: .medium))
                    .foregroundStyle(.secondary)
                    .tracking(0.5)

                Text(citation.findings)
                    .font(.system(size: DS.body))
                    .lineSpacing(DS.lineBody)
            }

            if !citation.relevance.isEmpty {
                VStack(alignment: .leading, spacing: DS.gapS) {
                    Text("為什麼相關")
                        .font(.system(size: DS.label, weight: .medium))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    Text(citation.relevance)
                        .font(.system(size: DS.bodyS))
                        .foregroundStyle(.primary.opacity(0.85))
                        .lineSpacing(DS.lineBody)
                }
                .padding(.top, DS.gapS)
            }

            if !citation.limitations.isEmpty {
                VStack(alignment: .leading, spacing: DS.gapS) {
                    Text("研究限制")
                        .font(.system(size: DS.label, weight: .medium))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    Text(citation.limitations)
                        .font(.system(size: DS.bodyS))
                        .foregroundStyle(.primary.opacity(0.85))
                        .lineSpacing(DS.lineBody)
                }
                .padding(.top, DS.gapS)
            }

            if let url = citation.pubmedURL, !url.isEmpty {
                Link(destination: URL(string: url) ?? URL(string: "https://pubmed.ncbi.nlm.nih.gov")!) {
                    HStack(spacing: DS.gapS) {
                        Image(systemName: "link")
                            .font(.system(size: DS.bodyS, weight: .medium))
                        Text("在 PubMed 查看")
                            .font(.system(size: DS.bodyS, weight: .medium))
                    }
                    .foregroundStyle(Color(hex: "#378ADD"))
                    .padding(.top, DS.gap)
                }
            }
        }
        .padding(DS.cardPadding)
        .background(Color.white)
        .cornerRadius(DS.radiusCard)
    }
}
