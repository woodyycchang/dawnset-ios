import Foundation

/// Generates patches to modify user's pipeline steps based on their described situation.
/// Currently uses keyword matching as a demo. Future: swap body with async URLSession call
/// to Claude API, passing user input + current pipeline + citation database.
enum AIModificationService {

    static func generatePatches(
        userInput: String,
        currentSteps: [PipelineType: [PipelineStep]]
    ) -> [AIPatch] {
        var patches: [AIPatch] = []
        let input = userInput.lowercased()
        let timestamp = Int(Date().timeIntervalSince1970)

        // Neck / shoulder / back issue → swap generic stretch for targeted activity
        if matches(input, patterns: ["頸", "肩", "脖", "腰", "背"]) {
            if let stretchStep = currentSteps[.morning]?.first(where: { $0.act.contains("伸展") }) {
                patches.append(AIPatch(
                    pipelineType: .morning,
                    kind: .modify(stepId: stretchStep.id,
                                  newAct: "頸椎溫和活動（參考物理治療）"),
                    reason: "你提到頸部或肩背問題，把一般伸展換成頸椎友善版本"
                ))
            }
        }

        // Caffeine sensitivity → lengthen water step before caffeine intake
        if matches(input, patterns: ["咖啡"]) {
            if let waterStep = currentSteps[.morning]?.first(where: { $0.act.contains("喝一杯水") }) {
                patches.append(AIPatch(
                    pipelineType: .morning,
                    kind: .adjust(stepId: waterStep.id, newMinutes: 3),
                    reason: "咖啡因敏感，先多補水作為緩衝"
                ))
            }
        }

        // Blood pressure / glucose tracking → insert as step 2 in morning
        if matches(input, patterns: ["血壓", "血糖"]) {
            let newId = "custom_bp_\(timestamp)"
            let step = PipelineStep(
                id: newId, act: "量血壓並記錄",
                minutes: 1, pillar: .avoidance, evidenceLevel: .custom,
                citationKey: "custom", points: 5)
            patches.append(AIPatch(
                pipelineType: .morning,
                kind: .add(position: 2, step: step),
                reason: "你提到想追蹤血壓"
            ))
        }

        // Gratitude / journal → add to bedtime
        if matches(input, patterns: ["感恩", "日記", "journal"]) {
            let newId = "custom_journal_\(timestamp)"
            let step = PipelineStep(
                id: newId, act: "寫三行日記（可語音）",
                minutes: 2, pillar: .stress, evidenceLevel: .custom,
                citationKey: "custom", points: 5)
            patches.append(AIPatch(
                pipelineType: .bedtime,
                kind: .add(position: 3, step: step),
                reason: "你提到日記需求，睡前是最佳時段（Emmons 2003）"
            ))
        }

        // Shorten morning → compress breakfast
        if matches(input, patterns: ["縮短", "忙", "快", "簡短", "簡化"]) {
            if let breakfast = currentSteps[.morning]?.first(where: { $0.act.contains("早餐") }),
               (breakfast.minutes ?? 0) > 5 {
                patches.append(AIPatch(
                    pipelineType: .morning,
                    kind: .adjust(stepId: breakfast.id, newMinutes: 5),
                    reason: "你想縮短晨間流程，把早餐時間壓到 5 分鐘"
                ))
            }
        }

        // Meditation / mindfulness → add to workStart
        if matches(input, patterns: ["冥想", "正念"]) {
            let newId = "custom_mindful_\(timestamp)"
            let step = PipelineStep(
                id: newId, act: "3 分鐘正念呼吸",
                minutes: 3, pillar: .stress, evidenceLevel: .custom,
                citationKey: "custom", points: 5)
            patches.append(AIPatch(
                pipelineType: .workStart,
                kind: .add(position: 1, step: step),
                reason: "你提到冥想需求，工作前是理想切換點"
            ))
        }

        return patches
    }

    /// Apply a list of patches to user steps, mutating the map.
    /// Returns the set of step IDs newly added or modified (for custom-marking).
    static func applyPatches(
        _ patches: [AIPatch],
        to userSteps: inout [PipelineType: [PipelineStep]]
    ) -> Set<String> {
        var touched: Set<String> = []

        for patch in patches {
            var steps = userSteps[patch.pipelineType] ?? []

            switch patch.kind {
            case .add(let position, let step):
                let idx = max(0, min(position - 1, steps.count))
                steps.insert(step, at: idx)
                touched.insert(step.id)

            case .modify(let stepId, let newAct):
                if let i = steps.firstIndex(where: { $0.id == stepId }) {
                    steps[i].act = newAct
                    steps[i].citationKey = "custom"
                    steps[i].evidenceLevel = .custom
                    touched.insert(stepId)
                }

            case .adjust(let stepId, let newMinutes):
                if let i = steps.firstIndex(where: { $0.id == stepId }) {
                    steps[i].minutes = newMinutes
                    touched.insert(stepId)
                }

            case .remove(let stepId):
                steps.removeAll { $0.id == stepId }
            }

            userSteps[patch.pipelineType] = steps
        }

        return touched
    }

    private static func matches(_ input: String, patterns: [String]) -> Bool {
        patterns.contains { input.contains($0) }
    }
}
