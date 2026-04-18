import Foundation

enum Citations {

    static let all: [String: Citation] = [
        "wright2013": Citation(
            id: "wright2013", level: .a,
            title: "Entrainment of the human circadian clock to the natural light–dark cycle",
            authors: "Wright KP Jr, McHill AW, Birks BR, Griffin BR, Rusterholz T, Chinoy ED",
            venue: "Current Biology, 23(16), 1554–1558 (2013)",
            findings: "在野外露營 1 週後，受試者的褪黑激素分泌時程完全對齊自然光暗周期，之前晚睡的人入睡時間平均提前 2 小時。",
            relevance: "晨起拉開窗簾或看窗外光線 2 到 10 分鐘，就能啟動晝夜節律，對夜貓型尤其有效。",
            limitations: "樣本數只有 8 人；戶外與室內條件差異劇烈；對極地或輪班者可能不適用。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/23910656/"),

        "masento2014": Citation(
            id: "masento2014", level: .a,
            title: "Effects of hydration status on cognitive performance and mood",
            authors: "Masento NA, Golightly M, Field DT, Butler LT, van Reekum CM",
            venue: "British Journal of Nutrition, 111(10), 1841–1852 (2014)",
            findings: "晨起輕度脫水（體重 1% 失水）即會降低短期記憶與情緒穩定度；補水 500 ml 後 20 分鐘內改善。",
            relevance: "晨起第一杯水是所有行為研究中性價比最高的動作之一。",
            limitations: "系統性回顧涵蓋小樣本研究；輕度脫水定義不統一。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/24480458/"),

        "stonge2017": Citation(
            id: "stonge2017", level: .a,
            title: "Meal timing and frequency: implications for cardiovascular disease prevention",
            authors: "St-Onge MP, Ard J, Baskin ML, et al. American Heart Association",
            venue: "Circulation, 135(9), e96–e121 (2017)",
            findings: "AHA 立場聲明：固定每日吃早餐與心血管風險降低相關；跳過早餐與 BMI、血脂不利模式有關。",
            relevance: "早餐本身不是魔法，固定時段的總熱量分配才是；晨間步驟把早餐放進固定 pipeline。",
            limitations: "觀察性研究多於 RCT；個體差異大。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/28137935/"),

        "behm2016": Citation(
            id: "behm2016", level: .a,
            title: "Acute effects of muscle stretching on physical performance",
            authors: "Behm DG, Blazevich AJ, Kay AD, McHugh M",
            venue: "Applied Physiology, Nutrition, and Metabolism, 41(1), 1–11 (2016)",
            findings: "動態伸展 3 到 5 分鐘能提升關節活動度與肌肉溫度，對當日後續活動表現有助益。",
            relevance: "晨間 3 分鐘動態伸展對肩頸、髖關節活動度有即時效果。",
            limitations: "多數研究對象為運動員；一般上班族長期效益證據較少。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/26642915/"),

        "gollwitzer2006": Citation(
            id: "gollwitzer2006", level: .a,
            title: "Implementation intentions and goal achievement: A meta-analysis of effects and processes",
            authors: "Gollwitzer PM, Sheeran P",
            venue: "Advances in Experimental Social Psychology, 38, 69–119 (2006)",
            findings: "94 篇研究 meta-analysis：寫下「如果 X 發生，我就做 Y」的執行意圖，把目標達成率平均提升 0.65 個標準差。",
            relevance: "晨間寫下今天最重要的一件事是行為意圖的具體化，執行率顯著高於空想。",
            limitations: "對習慣性困難（成癮、ADHD）效應較小；長期維持性未定。",
            pubmedURL: nil),

        "mark2008": Citation(
            id: "mark2008", level: .a,
            title: "The cost of interrupted work: More speed and stress",
            authors: "Mark G, Gudith D, Klocke U",
            venue: "CHI Conference Proceedings (2008)",
            findings: "工作被中斷後平均需要 23 分 15 秒才能回到原本的深度狀態；頻繁中斷時工作品質與情緒同時下降。",
            relevance: "深度工作前關通知不是儀式，是成本計算。",
            limitations: "實驗環境人工；不同工作性質中斷成本不同。",
            pubmedURL: nil),

        "locke2002": Citation(
            id: "locke2002", level: .a,
            title: "Building a practically useful theory of goal setting and task motivation",
            authors: "Locke EA, Latham GP",
            venue: "American Psychologist, 57(9), 705–717 (2002)",
            findings: "35 年研究總結：具體、有挑戰但可達的目標，比空泛的盡力而為多出 20 到 25% 產出。",
            relevance: "深度工作前寫下這段時間要完成什麼，把模糊變具體。",
            limitations: "在高度不確定、創造性任務中目標設定可能反噬。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/12237980/"),

        "zaccaro2018": Citation(
            id: "zaccaro2018", level: .a,
            title: "How breath-control can change your life: A systematic review on psycho-physiological correlates of slow breathing",
            authors: "Zaccaro A, Piarulli A, Laurino M, Garbella E, Menicucci D, Neri B, Gemignani A",
            venue: "Frontiers in Human Neuroscience, 12, 353 (2018)",
            findings: "慢式呼吸（每分鐘 6 次以下）活化副交感神經，降低皮質醇、提升注意力集中度。",
            relevance: "深度工作前 / 睡前 / 午後降壓都用到此機制，成本最低的調節手段。",
            limitations: "個體反應差異大；部分焦慮型在屏息時反而更緊張。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/30245619/"),

        "gooley2011": Citation(
            id: "gooley2011", level: .a,
            title: "Exposure to room light before bedtime suppresses melatonin onset and shortens melatonin duration in humans",
            authors: "Gooley JJ, Chamberlain K, Smith KA, et al.",
            venue: "Journal of Clinical Endocrinology & Metabolism, 96(3), E463–472 (2011)",
            findings: "睡前 8 小時暴露於一般房間亮度（200 lux）即會顯著延後褪黑激素分泌，延長入睡時間約 90 分鐘。",
            relevance: "睡前調暗燈光比你想的重要得多。",
            limitations: "個體差異大；幼兒與老人反應不同。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/21193540/"),

        "chang2015": Citation(
            id: "chang2015", level: .a,
            title: "Evening use of light-emitting eReaders negatively affects sleep",
            authors: "Chang AM, Aeschbach D, Duffy JF, Czeisler CA",
            venue: "PNAS, 112(4), 1232–1237 (2015)",
            findings: "睡前 4 小時使用電子閱讀器抑制褪黑激素 55%、延遲入睡時程 10 分鐘、次日清晨警覺度下降。",
            relevance: "手機離開臥房是這篇研究的直接應用。",
            limitations: "樣本小（12 人）；僅 5 晚實驗。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/25535358/"),

        "emmons2003": Citation(
            id: "emmons2003", level: .a,
            title: "Counting blessings versus burdens: An experimental investigation of gratitude and subjective well-being",
            authors: "Emmons RA, McCullough ME",
            venue: "Journal of Personality and Social Psychology, 84(2), 377–389 (2003)",
            findings: "3 個週記中寫感恩事件的組別，比寫煩惱的組別睡眠品質、主觀幸福感、體能均顯著較高。",
            relevance: "睡前寫 3 件感謝的事是該研究的一行版本。",
            limitations: "主觀量表依賴自陳；長期維持性不明。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/12585811/"),

        "ong2014": Citation(
            id: "ong2014", level: .b,
            title: "A randomized controlled trial of mindfulness meditation for chronic insomnia",
            authors: "Ong JC, Manber R, Segal Z, Xia Y, Shapiro S, Wyatt JK",
            venue: "Sleep, 37(9), 1553–1563 (2014)",
            findings: "8 週正念訓練組失眠嚴重度指數下降 8.8 分，對照組 3.4 分；入睡潛伏期縮短 23 分鐘。",
            relevance: "閉眼感受身體 1 到 2 分鐘是正念的最小劑量。",
            limitations: "訓練有投入門檻；急性失眠效果不如慢性。",
            pubmedURL: "https://pubmed.ncbi.nlm.nih.gov/25142566/"),

        "custom": Citation(
            id: "custom", level: .custom,
            title: "AI 根據你的情況加入",
            authors: "個人化調整",
            venue: "",
            findings: "這是 AI 根據你的自述加入或修改的步驟。",
            relevance: "針對你的個別需求做的調整。",
            limitations: "不是原廠研究建議，是個人化。",
            pubmedURL: nil)
    ]

    static func byKey(_ key: String?) -> Citation? {
        guard let k = key else { return nil }
        return all[k]
    }
}
