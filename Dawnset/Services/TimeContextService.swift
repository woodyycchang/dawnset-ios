import Foundation

/// Recommends which pipeline to show based on:
///  - whether the user has completed morning today (primary gate)
///  - hours since wake (when wake detected)
///  - absolute clock time (fallback for bedtime triggers)
enum TimeContext {
    case pipeline(PipelineType, reason: String)
    case allDone
    case empty(reason: String)
}

struct TimeContextService {

    /// Returns a recommended context given today's wake time, completion state, and clock.
    static func recommendation(
        wakeTime: Date?,
        completed: [PipelineType: Bool],
        now: Date = Date()
    ) -> TimeContext {
        let hoursSinceWake: Double = {
            guard let wake = wakeTime else { return 0 }
            return now.timeIntervalSince(wake) / 3600.0
        }()

        let calendar = Calendar.current
        let absHour = calendar.component(.hour, from: now)

        let morningDone = completed[.morning] ?? false
        let workStartDone = completed[.workStart] ?? false
        let afternoonDone = completed[.afternoon] ?? false
        let bedtimeDone = completed[.bedtime] ?? false

        // Primary gate: morning is the anchor. Until it is done, keep pushing it.
        if !morningDone {
            let reason: String
            if hoursSinceWake < 2 {
                reason = "剛醒來，先從晨間開始"
            } else if hoursSinceWake < 6 {
                reason = "今天還沒跑晨間流程"
            } else {
                reason = "晨間流程還沒做，跑縮短版也好"
            }
            return .pipeline(.morning, reason: reason)
        }

        // Post-morning: relative time drives the rest.
        if !workStartDone && hoursSinceWake < 4 {
            return .pipeline(.workStart, reason: "準備進入深度工作")
        }
        if !afternoonDone && hoursSinceWake >= 3 && hoursSinceWake < 9 {
            return .pipeline(.afternoon, reason: "下午了，重啟一下")
        }
        if !bedtimeDone && (hoursSinceWake >= 8 || absHour >= 20 || absHour < 4) {
            return .pipeline(.bedtime, reason: "該降檔準備睡覺")
        }

        // All pipelines completed
        if morningDone && bedtimeDone {
            return .allDone
        }

        // In-between gap (e.g. morning done, not yet deep work time)
        return .empty(reason: "這個時間你不需要 Dawnset")
    }

    /// Detects if a new day started since the last recorded session.
    static func isNewDay(lastSessionDate: Date?, now: Date = Date()) -> Bool {
        guard let last = lastSessionDate else { return true }
        return !Calendar.current.isDate(last, inSameDayAs: now)
    }

    /// Whether to record wake time on this open. True if no wake time recorded today.
    static func shouldRecordWakeTime(wakeTime: Date?, now: Date = Date()) -> Bool {
        guard let wake = wakeTime else { return true }
        return !Calendar.current.isDate(wake, inSameDayAs: now)
    }
}
