//
//  PipelineStep.swift
//  Dawnset MVP
//
//  一個步驟的資料結構。未來可以擴展到 SwiftData，現在先用記憶體模型。
//

import Foundation

struct PipelineStep: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String           // 主標題，例如 "喝一杯水"
    let subtitle: String        // 副標題說明
    let durationSeconds: Int    // 建議秒數
    let hasResearch: Bool       // 是否有論文背書（綠標）
}

// 定義晨間流程（MVP 版本：只有 3 步）
struct MorningPipeline {
    static let steps: [PipelineStep] = [
        PipelineStep(
            title: "喝一杯水",
            subtitle: "約 300-500ml，常溫。啟動身體代謝。",
            durationSeconds: 60,
            hasResearch: true
        ),
        PipelineStep(
            title: "伸展身體",
            subtitle: "站起來，拉拉手臂與肩頸。喚醒肌肉。",
            durationSeconds: 90,
            hasResearch: true
        ),
        PipelineStep(
            title: "寫下今日一件要事",
            subtitle: "拿紙筆或手機記事，寫下今天最重要的一件事。",
            durationSeconds: 120,
            hasResearch: false
        ),
    ]
}
