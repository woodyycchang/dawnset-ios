import SwiftUI

enum StepPillar: String, Codable, CaseIterable {
    case nutrition
    case activity
    case sleep
    case stress
    case connection
    case avoidance
    case none

    var displayName: String {
        switch self {
        case .nutrition:  return "營養"
        case .activity:   return "身體活動"
        case .sleep:      return "修復性睡眠"
        case .stress:     return "壓力管理"
        case .connection: return "連結感"
        case .avoidance:  return "避免風險物質"
        case .none:       return "日常"
        }
    }

    var color: Color {
        switch self {
        case .nutrition:  return Color(hex: "#1D9E75")
        case .activity:   return Color(hex: "#BA7517")
        case .sleep:      return Color(hex: "#534AB7")
        case .stress:     return Color(hex: "#378ADD")
        case .connection: return Color(hex: "#D4537E")
        case .avoidance:  return Color(hex: "#0F6E56")
        case .none:       return Color(hex: "#888780")
        }
    }
}
