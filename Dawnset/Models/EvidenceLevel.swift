import SwiftUI

enum EvidenceLevel: String, Codable {
    case a = "A"
    case b = "B"
    case c = "C"
    case custom
    case none

    var displayName: String {
        switch self {
        case .a:      return "A 級證據"
        case .b:      return "B 級證據"
        case .c:      return "C 級證據"
        case .custom: return "AI 客製"
        case .none:   return "日常"
        }
    }

    var description: String {
        switch self {
        case .a:      return "系統性回顧 / Meta-analysis"
        case .b:      return "單篇 RCT / 高品質世代研究"
        case .c:      return "機制研究 / 專家共識"
        case .custom: return "根據你的情況調整"
        case .none:   return ""
        }
    }

    var backgroundColor: Color {
        switch self {
        case .a:      return Color(hex: "#E1F5EE")
        case .b:      return Color(hex: "#E6F1FB")
        case .c:      return Color(hex: "#F1EFE8")
        case .custom: return Color(hex: "#E6F1FB")
        case .none:   return Color(hex: "#F5F4EF")
        }
    }

    var foregroundColor: Color {
        switch self {
        case .a:      return Color(hex: "#0F6E56")
        case .b:      return Color(hex: "#0C447C")
        case .c:      return Color(hex: "#444441")
        case .custom: return Color(hex: "#0C447C")
        case .none:   return Color(hex: "#888780")
        }
    }
}
