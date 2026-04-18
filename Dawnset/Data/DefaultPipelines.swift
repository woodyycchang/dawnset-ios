import Foundation

enum DefaultPipelines {

    static let morning: [PipelineStep] = [
        PipelineStep(id: "m1", act: "起床", points: 2),
        PipelineStep(id: "m2", act: "喝一杯水", minutes: 2,
                     pillar: .nutrition, evidenceLevel: .a,
                     citationKey: "masento2014", points: 10),
        PipelineStep(id: "m3", act: "拉開窗簾",
                     pillar: .sleep, evidenceLevel: .a,
                     citationKey: "wright2013", points: 10),
        PipelineStep(id: "m4", act: "上廁所、洗臉、刷牙", minutes: 5, points: 2),
        PipelineStep(id: "m5", act: "簡單伸展", minutes: 3,
                     pillar: .activity, evidenceLevel: .a,
                     citationKey: "behm2016", points: 10),
        PipelineStep(id: "m6", act: "穿衣", minutes: 3, points: 2),
        PipelineStep(id: "m7", act: "吃早餐", minutes: 8,
                     pillar: .nutrition, evidenceLevel: .a,
                     citationKey: "stonge2017", points: 10),
        PipelineStep(id: "m8", act: "到窗邊或戶外曬一下太陽", minutes: 3,
                     pillar: .sleep, evidenceLevel: .a,
                     citationKey: "wright2013", points: 10),
        PipelineStep(id: "m9", act: "寫下今天最重要的一件事", minutes: 2,
                     pillar: .stress, evidenceLevel: .a,
                     citationKey: "gollwitzer2006", points: 10),
        PipelineStep(id: "m10", act: "確認鑰匙、錢包、手機", points: 2),
        PipelineStep(id: "m11", act: "出發", points: 2)
    ]

    static let workStart: [PipelineStep] = [
        PipelineStep(id: "w1", act: "關閉所有通知", minutes: 0.25,
                     pillar: .stress, evidenceLevel: .a,
                     citationKey: "mark2008", points: 10),
        PipelineStep(id: "w2", act: "寫下這段時間要完成什麼", minutes: 1,
                     pillar: .stress, evidenceLevel: .a,
                     citationKey: "locke2002", points: 10),
        PipelineStep(id: "w3", act: "方形呼吸 4x4 循環", minutes: 1,
                     pillar: .stress, evidenceLevel: .a,
                     citationKey: "zaccaro2018", points: 10),
        PipelineStep(id: "w4", act: "喝一口水、坐直", minutes: 0.5, points: 2)
    ]

    static let afternoon: [PipelineStep] = [
        PipelineStep(id: "a1", act: "站起來走到最遠的窗邊", minutes: 1,
                     pillar: .sleep, evidenceLevel: .a,
                     citationKey: "wright2013", points: 10),
        PipelineStep(id: "a2", act: "喝一大杯水", minutes: 1,
                     pillar: .nutrition, evidenceLevel: .a,
                     citationKey: "masento2014", points: 10),
        PipelineStep(id: "a3", act: "轉動肩頸、站姿伸展", minutes: 1.5,
                     pillar: .activity, evidenceLevel: .a,
                     citationKey: "behm2016", points: 10),
        PipelineStep(id: "a4", act: "深呼吸三次回到座位", minutes: 0.5,
                     pillar: .stress, evidenceLevel: .a,
                     citationKey: "zaccaro2018", points: 10)
    ]

    static let bedtime: [PipelineStep] = [
        PipelineStep(id: "b1", act: "調暗室內燈光", minutes: 0.5,
                     pillar: .sleep, evidenceLevel: .a,
                     citationKey: "gooley2011", points: 10),
        PipelineStep(id: "b2", act: "手機放到另一個房間", minutes: 1,
                     pillar: .sleep, evidenceLevel: .a,
                     citationKey: "chang2015", points: 10),
        PipelineStep(id: "b3", act: "寫下今天三件感謝的事", minutes: 2,
                     pillar: .stress, evidenceLevel: .a,
                     citationKey: "emmons2003", points: 10),
        PipelineStep(id: "b4", act: "緩慢腹式呼吸 2 分鐘", minutes: 2,
                     pillar: .stress, evidenceLevel: .a,
                     citationKey: "zaccaro2018", points: 10),
        PipelineStep(id: "b5", act: "閉眼感受身體放鬆", minutes: 1.5,
                     pillar: .sleep, evidenceLevel: .b,
                     citationKey: "ong2014", points: 5)
    ]

    static func steps(for type: PipelineType) -> [PipelineStep] {
        switch type {
        case .morning:   return morning
        case .workStart: return workStart
        case .afternoon: return afternoon
        case .bedtime:   return bedtime
        }
    }

    /// Estimated total minutes for a pipeline (treating nil as 0.5 minutes each).
    static func totalMinutes(for steps: [PipelineStep]) -> Double {
        steps.reduce(0) { $0 + ($1.minutes ?? 0.5) }
    }
}
