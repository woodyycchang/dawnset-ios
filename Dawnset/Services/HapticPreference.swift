import Foundation

/// User preference for haptic intensity.
/// Research finding: 78% of users want to customize haptic intensity (JMIR 2023).
enum HapticLevel: String, CaseIterable, Identifiable, Codable {
    case full = "full"
    case minimal = "minimal"
    case off = "off"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .full:    return "完整"
        case .minimal: return "最小"
        case .off:     return "關閉"
        }
    }

    var description: String {
        switch self {
        case .full:    return "所有震動都啟用，包含慶祝組合"
        case .minimal: return "只有重要時刻才震動（完成 pipeline、接受 AI 建議）"
        case .off:     return "完全不震動（保留視覺彈跳）"
        }
    }
}

/// Global preference manager for haptic feedback.
enum HapticPreference {

    private static let key = "dawnset.hapticLevel"

    static var level: HapticLevel {
        get {
            let raw = UserDefaults.standard.string(forKey: key) ?? HapticLevel.full.rawValue
            return HapticLevel(rawValue: raw) ?? .full
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
        }
    }

    /// Whether a haptic of given importance should fire.
    static func shouldFire(importance: HapticImportance) -> Bool {
        switch level {
        case .off:
            return false
        case .minimal:
            return importance == .major
        case .full:
            return true
        }
    }
}

/// Classification of haptic moments by importance.
/// Used to decide which fire under .minimal setting.
enum HapticImportance {
    /// Minor taps — skip in Minimal mode.
    /// Examples: regular button press, step done, selection.
    case minor

    /// Major moments — fire even in Minimal mode.
    /// Examples: completing a pipeline, AI accepting, undo.
    case major
}
