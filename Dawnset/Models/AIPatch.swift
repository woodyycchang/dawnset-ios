import Foundation

enum AIPatchKind {
    case add(position: Int, step: PipelineStep)
    case modify(stepId: String, newAct: String)
    case adjust(stepId: String, newMinutes: Double?)
    case remove(stepId: String)
}

struct AIPatch: Identifiable {
    let id = UUID()
    let pipelineType: PipelineType
    let kind: AIPatchKind
    let reason: String
}

struct AIModification: Codable {
    let timestamp: Date
    let userInput: String
    let patchCount: Int
}
