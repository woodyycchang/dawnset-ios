import Foundation

struct CompletionRecord: Codable, Identifiable {
    let id: UUID
    let type: PipelineType
    let score: Int
    let completedAt: Date
    let stepOutcomes: [StepCompletionState?]

    init(type: PipelineType, score: Int, completedAt: Date = Date(),
         stepOutcomes: [StepCompletionState?]) {
        self.id = UUID()
        self.type = type
        self.score = score
        self.completedAt = completedAt
        self.stepOutcomes = stepOutcomes
    }
}

struct StepAction: Codable {
    let stepIndex: Int
    let action: StepCompletionState
    let scoreDelta: Int
}

struct PausedPipelineState: Codable {
    let type: PipelineType
    let stepIndex: Int
    let stepDoneStates: [StepCompletionState?]
}
