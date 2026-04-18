import Foundation
import SwiftUI

enum PipelineType: String, CaseIterable, Codable, Identifiable {
    case morning
    case workStart
    case afternoon
    case bedtime

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .morning:   return "晨間流程"
        case .workStart: return "深度工作前"
        case .afternoon: return "午後重啟"
        case .bedtime:   return "睡前降檔"
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .morning:
            return LinearGradient(
                colors: [Color(hex: "#BA7517"), Color(hex: "#FAC775")],
                startPoint: .top, endPoint: .bottom)
        case .workStart:
            return LinearGradient(
                colors: [Color(hex: "#378ADD"), Color(hex: "#B5D4F4")],
                startPoint: .top, endPoint: .bottom)
        case .afternoon:
            return LinearGradient(
                colors: [Color(hex: "#1D9E75"), Color(hex: "#9FE1CB")],
                startPoint: .top, endPoint: .bottom)
        case .bedtime:
            return LinearGradient(
                colors: [Color(hex: "#534AB7"), Color(hex: "#AFA9EC")],
                startPoint: .top, endPoint: .bottom)
        }
    }

    var accentColor: Color {
        switch self {
        case .morning:   return Color(hex: "#BA7517")
        case .workStart: return Color(hex: "#378ADD")
        case .afternoon: return Color(hex: "#1D9E75")
        case .bedtime:   return Color(hex: "#534AB7")
        }
    }
}
