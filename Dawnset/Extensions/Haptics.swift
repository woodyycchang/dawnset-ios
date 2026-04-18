import UIKit

/// Calibrated haptic feedback system.
///
/// Research-aligned principles (Apple HIG + Mark 2011 + JMIR 2023):
///   - Default to light feedback for common actions (soft)
///   - Match intensity to importance, not to feel
///   - Fire on completion/destination, not during action
///   - Respect user preference (Full / Minimal / Off)
///
/// Zenly-inspired choices kept:
///   - Multi-stage haptics for rare celebration moments (tadaa, celebration)
///   - Visual bounce on buttons (not in this file — see PressableStyle)
enum Haptics {

    private static let soft   = UIImpactFeedbackGenerator(style: .soft)
    private static let light  = UIImpactFeedbackGenerator(style: .light)
    private static let medium = UIImpactFeedbackGenerator(style: .medium)
    private static let heavy  = UIImpactFeedbackGenerator(style: .heavy)
    private static let rigid  = UIImpactFeedbackGenerator(style: .rigid)
    private static let notify = UINotificationFeedbackGenerator()
    private static let select = UISelectionFeedbackGenerator()

    static func prime() {
        [soft, light, medium, heavy, rigid].forEach { $0.prepare() }
        notify.prepare()
        select.prepare()
    }

    // MARK: - Minor haptics (filtered under Minimal mode)

    /// Very light confirmation. Use for generic button presses.
    /// Calibrated: was `.medium` in Zenly version, now `.soft` for daily-use fatigue resistance.
    static func tap() {
        guard HapticPreference.shouldFire(importance: .minor) else { return }
        soft.impactOccurred(intensity: 0.8)
        soft.prepare()
    }

    /// Selection changed (like a picker). Lightest confirmation.
    static func selection() {
        guard HapticPreference.shouldFire(importance: .minor) else { return }
        select.selectionChanged()
        select.prepare()
    }

    /// Whisper-light feedback for background/secondary actions.
    static func whisper() {
        guard HapticPreference.shouldFire(importance: .minor) else { return }
        soft.impactOccurred(intensity: 0.6)
        soft.prepare()
    }

    // MARK: - Major haptics (always fire, except in Off mode)

    /// Sharp click feel for decisive/destructive actions.
    /// Examples: undo, jump-to-step.
    static func click() {
        guard HapticPreference.shouldFire(importance: .major) else { return }
        rigid.impactOccurred(intensity: 1.0)
        rigid.prepare()
    }

    /// Warning feedback (e.g., reset all customizations).
    static func warn() {
        guard HapticPreference.shouldFire(importance: .major) else { return }
        notify.notificationOccurred(.warning)
        notify.prepare()
    }

    /// Error feedback.
    static func error() {
        guard HapticPreference.shouldFire(importance: .major) else { return }
        notify.notificationOccurred(.error)
        notify.prepare()
    }

    // MARK: - Celebration combos (major — fire even in Minimal)

    /// "Ta-da!" — mid-tap → brief pause → success chime.
    /// Use when: pipeline complete, AI patches accepted.
    static func tadaa() {
        guard HapticPreference.shouldFire(importance: .major) else { return }
        medium.impactOccurred(intensity: 0.85)
        medium.prepare()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
            guard HapticPreference.shouldFire(importance: .major) else { return }
            notify.notificationOccurred(.success)
            notify.prepare()
        }
    }

    /// "Ti-di-dum!" — 3-stage ramp for biggest moments.
    /// Use when: all done for today, onboarding complete.
    static func celebration() {
        guard HapticPreference.shouldFire(importance: .major) else { return }
        soft.impactOccurred(intensity: 0.7)
        soft.prepare()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.09) {
            guard HapticPreference.shouldFire(importance: .major) else { return }
            medium.impactOccurred(intensity: 0.9)
            medium.prepare()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            guard HapticPreference.shouldFire(importance: .major) else { return }
            notify.notificationOccurred(.success)
            notify.prepare()
        }
    }
}
