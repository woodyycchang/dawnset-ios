import Foundation

struct Citation: Codable, Identifiable {
    let id: String
    let level: EvidenceLevel
    let title: String
    let authors: String
    let venue: String
    let findings: String
    let relevance: String
    let limitations: String
    let pubmedURL: String?
}
