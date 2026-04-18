# Dawnset

> Speedrun 每天必要的事，做完離開 App。

Dawnset 是一款基於 ACLM 六支柱的每日 pipeline 工具。使用者打開 App → 看到當下時段的 pipeline → 跟著做完 → 看到「一切必要的都完成了」→ 離開。

## 當前狀態

v0.2 — 兩個關鍵設計修正：

- **Onboarding 移除問卷**：只剩品牌頁，按「開始」直接進主畫面（與「無腦」哲學對齊）
- **時段無縫銜接**：04:00–10:30 morning / 10:30–13:00 workStart / 13:00–21:30 afternoon / 21:30–次日 04:00 bedtime — **所有時段都推薦 pipeline，沒有空白時段。** EmptyStateView 不再被 HomeView 使用（保留檔案供未來特殊場景）

v0.1 完成的基底：

| Stage | 內容 | 狀態 |
|---|---|---|
| 1 | 資料模型 + seeds | done |
| 2 | 設計系統 + 元件 | done |
| 3 | 核心畫面（Home / Pipeline / Aha） | done |
| 4 | 次要畫面（Citation / LowEnergy / Onboarding / Impact） | done |
| 5 | Widget + services | done |
| 6 | 單元測試 + Localizable | done |

## 在 Xcode 開啟

這份 repo 只有 Swift 原始碼。要跑起來需要在 Xcode 建 project 並掛入這些檔案。

> **重要：Widget 檔案不可與主 App 同 target！**
> `Dawnset/Widget/DawnsetWidget.swift` 宣告了 `@main struct DawnsetWidgetBundle`，
> `Dawnset/DawnsetApp.swift` 也宣告了 `@main struct DawnsetApp`。
> 一個 target 裡不能有兩個 `@main`，會 compile error：
> `multiple @main attributes`。
> 所以 `Dawnset/Widget/` 的兩個檔案**只能**掛在 Widget Extension target。

### 主 App target：Dawnset
- **Bundle ID**：`com.woodyyc.dawnset`
- **Platform**：iOS 17.0+
- **Interface**：SwiftUI
- **Storage**：SwiftData
- 把 `Dawnset/` 底下**除了** `Widget/` 以外的所有檔案加入此 target
- 把 `Dawnset/Resources/Assets.xcassets` 加入此 target
- 把 `Dawnset/Resources/zh-Hant.lproj/Localizable.strings` 加入（在 Localizations 勾選 Traditional Chinese）
- **Info.plist 加入 URL scheme 以接收 widget deep link**：
  ```xml
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleURLSchemes</key>
      <array><string>dawnset</string></array>
    </dict>
  </array>
  ```

### Widget Extension target：DawnsetWidget
- File → New → Target → Widget Extension
- **Bundle ID**：`com.woodyyc.dawnset.widget`
- 把 `Dawnset/Widget/DawnsetWidget.swift` 與 `WidgetProvider.swift` 加入此 target
- **千萬不要**把這兩個檔案也加入主 App target（見上方警告）
- `DawnsetWidget.swift` 需要用到 `TimeGradient` 與 `Color.morningStart` 等，所以把 `Dawnset/DesignSystem.swift`、`Dawnset/Models/Pipeline.swift`、`Dawnset/Models/PipelineStep.swift`、`Dawnset/Models/Pillar.swift`、`Dawnset/Data/PipelineSeeds.swift`、`Dawnset/Data/CitationSeeds.swift`、`Dawnset/Services/TimeContextService.swift` 的 **Target Membership** 勾選 Widget target（這些檔案同時屬於兩個 target）
- `Dawnset/Resources/Assets.xcassets` 的 Target Membership 也勾 Widget
- **（進階）App Group**：Widget 與 App 要共享 UserDefaults（`widget.morningCompletedDate`）
  需在兩個 target 勾 App Groups capability（例如 `group.com.woodyyc.dawnset`），
  並把 `UserDefaults.standard` 改為 `UserDefaults(suiteName: "group.com.woodyyc.dawnset")`。
  目前 code 先用 `.standard` 跑 App 單機邏輯；widget 讀不到僅表示 workStart 推薦不會自動切換。

### Test target：DawnsetTests
- File → New → Target → Unit Testing Bundle
- 把 `DawnsetTests/ImpactScoreServiceTests.swift` 加入此 target
- Cmd+U 跑測試（已附 11 個 case）

## 專案結構

```
Dawnset/
├── DawnsetApp.swift                    App 進入點 + SwiftData container + deep link
├── DesignSystem.swift                Typo / Spacing / Corners / TimeGradient / Haptics
├── Models/
│   ├── Pillar.swift                  ACLM 六支柱 + EvidenceLevel
│   ├── Pipeline.swift                @Model + PipelineType
│   ├── PipelineStep.swift            @Model
│   ├── Citation.swift                @Model（含限制欄位）
│   ├── CompletionRecord.swift        @Model
│   └── ImpactScore.swift             計算核心（非 @Model）
├── Views/
│   ├── Onboarding/OnboardingView.swift
│   ├── Home/HomeView.swift
│   ├── Home/EmptyStateView.swift
│   ├── Pipeline/PipelineRunView.swift
│   ├── Pipeline/StepRowView.swift
│   ├── Pipeline/LowEnergyModeView.swift
│   ├── Completion/AhaView.swift
│   ├── Citation/CitationDetailView.swift
│   ├── Impact/WeeklyImpactView.swift
│   ├── ProgressBar.swift
│   └── SciBadge.swift
├── Widget/
│   ├── DawnsetWidget.swift             Small + Medium families + deep-link
│   └── WidgetProvider.swift          TimelineProvider
├── Data/
│   ├── PipelineSeeds.swift           4 pipelines per spec
│   └── CitationSeeds.swift           12 論文（佔位，須專業審訂）
├── Services/
│   ├── TimeContextService.swift
│   ├── ImpactScoreService.swift
│   └── PillarCoverageService.swift
└── Resources/
    ├── Assets.xcassets/              14 color sets（含 dark-mode 動態）
    └── zh-Hant.lproj/Localizable.strings

DawnsetTests/
└── ImpactScoreServiceTests.swift     11 個單元測試
```

## 設計哲學重點（刻意不做）

- 不連續打卡、不推播、不排行榜、不遊戲化
- 不要求註冊，一切本地
- 「不需要 Dawnset 的時間」明確顯示，不誘導使用
- 論文引用必含「限制」欄位，誠實說明侷限

## 警告

所有論文引用（12 篇）目前為佔位。上架前須由 Cornell Weill 醫學院或相當等級
的專業審訂者到 PubMed 逐篇核對作者、年份、期刊、findings 與 limitations。
