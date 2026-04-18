import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {

    // MARK: - Navigation

    enum Screen: Equatable {
        case onboarding, home, pipeline, aha, lowEnergy, empty, impact
    }

    enum ActiveSheet: Identifiable {
        case citation(key: String)
        case manualPicker
        case agent
        case patchPreview
        case pillarInfo(type: PipelineType)
        case settings

        var id: String {
            switch self {
            case .citation(let key): return "citation.\(key)"
            case .manualPicker:      return "manualPicker"
            case .agent:             return "agent"
            case .patchPreview:      return "patchPreview"
            case .pillarInfo(let t): return "pillarInfo.\(t.rawValue)"
            case .settings:          return "settings"
            }
        }
    }

    // MARK: - Published state

    @Published var screen: Screen = .onboarding
    @Published var hasOnboarded: Bool = false
    @Published var activeSheet: ActiveSheet?

    @Published var wakeTime: Date?

    @Published var runningType: PipelineType?
    @Published var runningSteps: [PipelineStep] = []
    @Published var currentStepIdx: Int = 0
    @Published var stepStates: [StepCompletionState?] = []
    @Published var stepHistory: [StepAction] = []

    @Published var todayScore: Int = 0
    @Published var completed: [PipelineType: Bool] = [:]

    @Published var userSteps: [PipelineType: [PipelineStep]] = [:]
    @Published var customIds: Set<String> = []
    @Published var pausedPipeline: PausedPipelineState?
    @Published var history: [CompletionRecord] = []
    @Published var aiHistory: [AIModification] = []

    @Published var lastAIInput: String = ""
    @Published var pendingPatches: [AIPatch] = []

    private let persistence = PersistenceManager()

    init() {
        load()
        Haptics.prime()
    }

    // MARK: - Lifecycle

    func onAppLaunch() {
        let now = Date()
        let lastSession = persistence.lastSessionDate

        if TimeContextService.isNewDay(lastSessionDate: lastSession, now: now) {
            rolloverToNewDay(at: now)
        }

        if TimeContextService.shouldRecordWakeTime(wakeTime: wakeTime, now: now) {
            wakeTime = now
            persistence.wakeTime = now
        }

        persistence.lastSessionDate = now
    }

    private func rolloverToNewDay(at now: Date) {
        completed = [:]
        todayScore = 0
        wakeTime = nil
        persistence.wakeTime = nil
        persistence.saveCompletedToday(completed)
        persistence.todayScore = 0
    }

    private func load() {
        hasOnboarded = persistence.hasOnboarded
        wakeTime = persistence.wakeTime
        todayScore = persistence.todayScore
        completed = persistence.loadCompletedToday()
        history = persistence.loadHistory()
        aiHistory = persistence.loadAIHistory()
        pausedPipeline = persistence.loadPaused()
        customIds = persistence.loadCustomIds()

        if let saved = persistence.loadUserSteps() {
            userSteps = saved
        } else {
            resetUserStepsToDefaults()
        }

        screen = hasOnboarded ? .home : .onboarding
    }

    private func resetUserStepsToDefaults() {
        userSteps = [
            .morning:   DefaultPipelines.morning,
            .workStart: DefaultPipelines.workStart,
            .afternoon: DefaultPipelines.afternoon,
            .bedtime:   DefaultPipelines.bedtime
        ]
    }

    // MARK: - Onboarding

    func completeOnboarding() {
        hasOnboarded = true
        persistence.hasOnboarded = true
        Haptics.celebration()     // First big moment: full 3-stage
        screen = .home
    }

    // MARK: - Recommendation

    var currentRecommendation: TimeContext {
        TimeContextService.recommendation(
            wakeTime: wakeTime,
            completed: completed
        )
    }

    var hoursSinceWake: Double {
        guard let wake = wakeTime else { return 0 }
        return Date().timeIntervalSince(wake) / 3600.0
    }

    // MARK: - Pipeline execution

    func startPipeline(_ type: PipelineType) {
        runningType = type
        runningSteps = userSteps[type] ?? []
        currentStepIdx = 0
        stepStates = Array(repeating: nil, count: runningSteps.count)
        stepHistory = []
        pausedPipeline = nil
        persistence.savePaused(nil)
        // Button style fires the press haptic (pressablePrimary)
        // no additional Haptics.xxx call needed here — avoid double-fire
        screen = .pipeline
    }

    func markCurrentStepDone() {
        guard currentStepIdx < runningSteps.count else { return }
        let step = runningSteps[currentStepIdx]
        let delta = step.points
        stepHistory.append(StepAction(stepIndex: currentStepIdx, action: .done, scoreDelta: delta))
        todayScore += delta
        stepStates[currentStepIdx] = .done
        // Calibrated: was .tap() → now .selection() (lightest confirmation)
        // Research: match intensity to importance. Per-step done is minor.
        Haptics.selection()
        advance()
    }

    func markCurrentStepSkipped() {
        guard currentStepIdx < runningSteps.count else { return }
        let step = runningSteps[currentStepIdx]
        let delta = Int((Double(step.points) * 0.5).rounded())
        stepHistory.append(StepAction(stepIndex: currentStepIdx, action: .skipped, scoreDelta: delta))
        todayScore += delta
        stepStates[currentStepIdx] = .skipped
        // Calibrated: no haptic on skip.
        // Research: skipping is not a celebration moment. Silence = respect for the user.
        advance()
    }

    func undoLastStep() {
        guard let last = stepHistory.popLast() else { return }
        todayScore -= last.scoreDelta
        stepStates[last.stepIndex] = nil
        currentStepIdx = last.stepIndex
        if screen == .aha { screen = .pipeline }
        persistence.todayScore = todayScore
        Haptics.click()           // Major: decisive action
    }

    func jumpToStep(_ index: Int) {
        guard index >= 0 && index < runningSteps.count else { return }
        currentStepIdx = index
        screen = .pipeline
        Haptics.selection()       // Minor: picker-like selection
    }

    private func advance() {
        if currentStepIdx >= runningSteps.count - 1 {
            Haptics.tadaa()       // ⭐ Major: pipeline done
            screen = .aha
        } else {
            currentStepIdx += 1
        }
        persistence.todayScore = todayScore
    }

    // MARK: - Pause / Resume

    func pausePipeline() {
        guard let type = runningType else {
            screen = .home
            return
        }
        if currentStepIdx > 0 || stepStates.contains(where: { $0 != nil }) {
            pausedPipeline = PausedPipelineState(
                type: type,
                stepIndex: currentStepIdx,
                stepDoneStates: stepStates
            )
            persistence.savePaused(pausedPipeline)
            // Calibrated: no haptic on pause. It's a navigation action, not a milestone.
        }
        screen = .home
    }

    func resumePausedPipeline() {
        guard let p = pausedPipeline else { return }
        runningType = p.type
        runningSteps = userSteps[p.type] ?? []
        currentStepIdx = p.stepIndex
        stepStates = p.stepDoneStates
        stepHistory = []
        pausedPipeline = nil
        persistence.savePaused(nil)
        // Button style fires press haptic. No additional.
        screen = .pipeline
    }

    func discardPaused() {
        pausedPipeline = nil
        persistence.savePaused(nil)
        // Calibrated: no haptic. Destructive-ish but minor.
    }

    // MARK: - Aha completion

    func leaveAha() {
        guard let type = runningType else {
            screen = .home
            return
        }
        completed[type] = true
        let record = CompletionRecord(
            type: type, score: todayScore,
            stepOutcomes: stepStates)
        history.append(record)
        persistence.saveCompletedToday(completed)
        persistence.saveHistory(history)

        let allDone = (completed[.morning] ?? false) && (completed[.bedtime] ?? false)
        if allDone {
            Haptics.celebration()  // Major: whole day complete
        }
        // Else: no haptic. tadaa already fired when entering Aha.
        screen = .home
    }

    func undoCompletion() {
        if runningType != nil {
            currentStepIdx = max(0, runningSteps.count - 1)
            screen = .pipeline
            Haptics.click()
        }
    }

    // MARK: - Manual picker

    func manualStart(_ type: PipelineType) {
        activeSheet = nil
        startPipeline(type)
    }

    // MARK: - Low energy

    func recordLowEnergyAction() {
        todayScore += 2
        persistence.todayScore = todayScore
        Haptics.tadaa()            // Major: celebrating tiny win
    }

    // MARK: - AI flow

    func runAIWithInput(_ input: String) {
        lastAIInput = input
        pendingPatches = AIModificationService.generatePatches(
            userInput: input,
            currentSteps: userSteps
        )
        // Calibrated: no haptic here. Button press style already fired.
        // Avoid double-fire / fatigue.
    }

    func acceptPendingPatches() {
        let touched = AIModificationService.applyPatches(pendingPatches, to: &userSteps)
        customIds.formUnion(touched)
        aiHistory.append(AIModification(
            timestamp: Date(),
            userInput: lastAIInput,
            patchCount: pendingPatches.count
        ))
        persistence.saveUserSteps(userSteps)
        persistence.saveCustomIds(customIds)
        persistence.saveAIHistory(aiHistory)
        pendingPatches = []
        lastAIInput = ""
        activeSheet = nil
        Haptics.tadaa()             // Major: AI accepted
    }

    func cancelPendingPatches() {
        pendingPatches = []
        lastAIInput = ""
        // Calibrated: no haptic on cancel. Button press already fired.
    }

    func resetAllCustomizations() {
        resetUserStepsToDefaults()
        customIds = []
        aiHistory = []
        persistence.saveUserSteps(userSteps)
        persistence.saveCustomIds(customIds)
        persistence.saveAIHistory(aiHistory)
        Haptics.warn()              // Major: destructive action
    }

    // MARK: - Debug / reset

    func resetAll() {
        persistence.wipeAll()
        hasOnboarded = false
        wakeTime = nil
        todayScore = 0
        completed = [:]
        history = []
        aiHistory = []
        pausedPipeline = nil
        customIds = []
        resetUserStepsToDefaults()
        runningType = nil
        runningSteps = []
        stepStates = []
        stepHistory = []
        currentStepIdx = 0
        pendingPatches = []
        lastAIInput = ""
        screen = .onboarding
    }

    // MARK: - Helpers

    func isCustom(_ stepId: String) -> Bool { customIds.contains(stepId) }

    func stepsFor(_ type: PipelineType) -> [PipelineStep] {
        userSteps[type] ?? DefaultPipelines.steps(for: type)
    }

    func totalMinutes(for type: PipelineType) -> Double {
        DefaultPipelines.totalMinutes(for: stepsFor(type))
    }

    var historicalAverageScore: Int {
        guard !history.isEmpty else { return 0 }
        let total = history.reduce(0) { $0 + $1.score }
        return Int((Double(total) / Double(history.count)).rounded())
    }
}
