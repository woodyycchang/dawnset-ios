import Foundation

/// Handles all JSON serialization to UserDefaults.
/// Single source of truth for persistence keys.
final class PersistenceManager {

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private enum Keys {
        static let hasOnboarded = "dawnset.hasOnboarded"
        static let wakeTime = "dawnset.wakeTime"
        static let lastSessionDate = "dawnset.lastSessionDate"
        static let userSteps = "dawnset.userSteps"
        static let customIds = "dawnset.customIds"
        static let completedToday = "dawnset.completedToday"
        static let history = "dawnset.history"
        static let todayScore = "dawnset.todayScore"
        static let pausedPipeline = "dawnset.pausedPipeline"
        static let aiHistory = "dawnset.aiHistory"
    }

    // MARK: - Primitives

    var hasOnboarded: Bool {
        get { defaults.bool(forKey: Keys.hasOnboarded) }
        set { defaults.set(newValue, forKey: Keys.hasOnboarded) }
    }

    var wakeTime: Date? {
        get { defaults.object(forKey: Keys.wakeTime) as? Date }
        set { defaults.set(newValue, forKey: Keys.wakeTime) }
    }

    var lastSessionDate: Date? {
        get { defaults.object(forKey: Keys.lastSessionDate) as? Date }
        set { defaults.set(newValue, forKey: Keys.lastSessionDate) }
    }

    var todayScore: Int {
        get { defaults.integer(forKey: Keys.todayScore) }
        set { defaults.set(newValue, forKey: Keys.todayScore) }
    }

    // MARK: - User steps (mutable pipeline layer)

    func saveUserSteps(_ steps: [PipelineType: [PipelineStep]]) {
        guard let data = try? encoder.encode(steps) else { return }
        defaults.set(data, forKey: Keys.userSteps)
    }

    func loadUserSteps() -> [PipelineType: [PipelineStep]]? {
        guard let data = defaults.data(forKey: Keys.userSteps),
              let decoded = try? decoder.decode([PipelineType: [PipelineStep]].self, from: data)
        else { return nil }
        return decoded
    }

    // MARK: - Custom step IDs (AI-added / modified)

    func saveCustomIds(_ ids: Set<String>) {
        defaults.set(Array(ids), forKey: Keys.customIds)
    }

    func loadCustomIds() -> Set<String> {
        let arr = defaults.stringArray(forKey: Keys.customIds) ?? []
        return Set(arr)
    }

    // MARK: - Completed today

    func saveCompletedToday(_ completed: [PipelineType: Bool]) {
        guard let data = try? encoder.encode(completed) else { return }
        defaults.set(data, forKey: Keys.completedToday)
    }

    func loadCompletedToday() -> [PipelineType: Bool] {
        guard let data = defaults.data(forKey: Keys.completedToday),
              let decoded = try? decoder.decode([PipelineType: Bool].self, from: data)
        else { return [:] }
        return decoded
    }

    // MARK: - History

    func saveHistory(_ history: [CompletionRecord]) {
        guard let data = try? encoder.encode(history) else { return }
        defaults.set(data, forKey: Keys.history)
    }

    func loadHistory() -> [CompletionRecord] {
        guard let data = defaults.data(forKey: Keys.history),
              let decoded = try? decoder.decode([CompletionRecord].self, from: data)
        else { return [] }
        return decoded
    }

    // MARK: - Paused pipeline

    func savePaused(_ paused: PausedPipelineState?) {
        guard let paused = paused,
              let data = try? encoder.encode(paused)
        else {
            defaults.removeObject(forKey: Keys.pausedPipeline)
            return
        }
        defaults.set(data, forKey: Keys.pausedPipeline)
    }

    func loadPaused() -> PausedPipelineState? {
        guard let data = defaults.data(forKey: Keys.pausedPipeline),
              let decoded = try? decoder.decode(PausedPipelineState.self, from: data)
        else { return nil }
        return decoded
    }

    // MARK: - AI history

    func saveAIHistory(_ history: [AIModification]) {
        guard let data = try? encoder.encode(history) else { return }
        defaults.set(data, forKey: Keys.aiHistory)
    }

    func loadAIHistory() -> [AIModification] {
        guard let data = defaults.data(forKey: Keys.aiHistory),
              let decoded = try? decoder.decode([AIModification].self, from: data)
        else { return [] }
        return decoded
    }

    // MARK: - Nuclear reset (debug)

    func wipeAll() {
        for key in [Keys.hasOnboarded, Keys.wakeTime, Keys.lastSessionDate,
                    Keys.userSteps, Keys.customIds, Keys.completedToday,
                    Keys.history, Keys.todayScore, Keys.pausedPipeline,
                    Keys.aiHistory] {
            defaults.removeObject(forKey: key)
        }
    }
}
