import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ZStack {
            currentScreen
                .animation(.easeInOut(duration: 0.25), value: state.screen)
        }
        .sheet(item: $state.activeSheet) { sheet in
            sheetContent(for: sheet)
        }
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch state.screen {
        case .onboarding:
            OnboardingView()
        case .home:
            HomeView()
        case .pipeline:
            PipelineRunView()
        case .aha:
            AhaView()
        case .lowEnergy:
            LowEnergyView()
        case .empty:
            HomeView()
        case .impact:
            ImpactView()
        }
    }

    @ViewBuilder
    private func sheetContent(for sheet: AppState.ActiveSheet) -> some View {
        switch sheet {
        case .citation(let key):
            CitationSheet(citationKey: key)
        case .manualPicker:
            ManualPickerSheet()
        case .agent:
            AgentSheet()
        case .patchPreview:
            PatchPreviewSheet()
        case .pillarInfo:
            EmptyView()
        case .settings:
            SettingsSheet()
        }
    }
}
