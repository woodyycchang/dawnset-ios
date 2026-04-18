import SwiftUI
import UIKit

/// Calibrated pressable button style.
///
/// Visual: keeps Zenly-style bouncy squish (scale 0.93, spring damping 0.55).
///   Rationale: visual bounce doesn't cause fatigue over daily use.
///
/// Haptic: reduced from .medium (Zenly) to .soft (calibrated).
///   Rationale: daily-use app triggers 50+ taps per day;
///   .medium on every tap causes fatigue per Apple HIG.
///   Preference-aware via Haptics.tap() which respects HapticPreference.
struct PressableStyle: ButtonStyle {
    var importance: HapticImportance = .minor
    var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    var intensity: CGFloat = 0.8
    var scale: CGFloat = 0.93
    var pressedOpacity: Double = 0.85

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? pressedOpacity : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.55),
                       value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                guard isPressed else { return }
                // Check user preference before firing
                guard HapticPreference.shouldFire(importance: importance) else { return }
                UIImpactFeedbackGenerator(style: hapticStyle)
                    .impactOccurred(intensity: intensity)
            }
    }
}

extension ButtonStyle where Self == PressableStyle {
    /// Default style — soft haptic, bouncy visual. For most buttons.
    static var pressable: PressableStyle { PressableStyle() }

    /// Primary CTA style — medium haptic, bouncy visual. For "開始", "做完", etc.
    /// Marked as .major so fires even in Minimal mode.
    static var pressablePrimary: PressableStyle {
        PressableStyle(
            importance: .major,
            hapticStyle: .medium,
            intensity: 0.9,
            scale: 0.92
        )
    }

    /// Tertiary style — no haptic from the style itself (only visual).
    /// Use for minor/repeated buttons like close, cancel, footer links.
    static var pressableQuiet: PressableStyle {
        PressableStyle(
            importance: .minor,
            hapticStyle: .soft,
            intensity: 0.4,
            scale: 0.96
        )
    }
}
