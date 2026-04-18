import Foundation

struct PipelineStep: Identifiable, Codable, Equatable {
    let id: String
    var act: String
    var minutes: Double?
    var pillar: StepPillar
    var evidenceLevel: EvidenceLevel
    var citationKey: String?
    var points: Int

    init(id: String, act: String, minutes: Double? = nil,
         pillar: StepPillar = .none,
         evidenceLevel: EvidenceLevel = .none,
         citationKey: String? = nil,
         points: Int = 2) {
        self.id = id
        self.act = act
        self.minutes = minutes
        self.pillar = pillar
        self.evidenceLevel = evidenceLevel
        self.citationKey = citationKey
        self.points = points
    }

    /// Display string for the minute estimate. Returns "—" when nil.
    var minuteString: String {
        guard let m = minutes else { return "—" }
        if m < 1 { return "\(Int(m * 60)) 秒" }
        if m == m.rounded() { return "\(Int(m)) 分" }
        return String(format: "%.1f 分", m)
    }
}

enum StepCompletionState: String, Codable {
    case done
    case skipped
}
