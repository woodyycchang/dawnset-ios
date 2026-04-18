import SwiftUI

/// Design tokens — single source of truth for typography, corner radius, and spacing.
///
/// Research-aligned scale:
///   - Apple HIG: body default 17pt, minimum 11pt
///   - Nielsen Norman: headers 24-28pt boost engagement +25%
///   - Smashing Magazine: line-height 1.4-1.6× body improves comprehension +12%
///   - Baymard: dense layouts double abandonment
///
/// Zenly-inspired:
///   - Larger corner radius (14-22pt) for friendly, rounded feel
///   - Generous spacing — feels like a game, not a form
enum DS {

    // MARK: - Typography

    /// 46pt — hero numbers, clock display
    static let display: CGFloat = 46

    /// 32pt — landing headlines
    static let titleXL: CGFloat = 32

    /// 28pt — screen titles, step names in pipeline
    static let titleL: CGFloat = 28

    /// 22pt — card titles, section headers
    static let titleM: CGFloat = 22

    /// 20pt — smaller section headers
    static let titleS: CGFloat = 20

    /// 17pt — body text (Apple HIG default)
    static let body: CGFloat = 17

    /// 15pt — secondary body, metadata, descriptions
    static let bodyS: CGFloat = 15

    /// 13pt — small labels, less emphasized rows
    static let label: CGFloat = 13

    /// 11pt — caption (absolute minimum per Apple HIG)
    static let caption: CGFloat = 11

    // MARK: - Line spacing (absolute points, added to default)
    // Default line-height is ~1.15 × font size.
    // Adding these values pushes toward 1.4-1.5× (research-optimal).

    static let lineBody: CGFloat = 6      // for body 17pt
    static let lineTitle: CGFloat = 4     // for titles
    static let lineCaption: CGFloat = 3   // for small text

    // MARK: - Corner radius

    /// 10pt — small chips, tags
    static let radiusChip: CGFloat = 10

    /// 14pt — primary buttons, CTAs
    static let radiusButton: CGFloat = 14

    /// 18pt — medium containers
    static let radiusMedium: CGFloat = 18

    /// 22pt — cards
    static let radiusCard: CGFloat = 22

    /// 28pt — large sheet corners (system default is 10, this feels Zenly)
    static let radiusLarge: CGFloat = 28

    // MARK: - Spacing

    /// 4pt — tight
    static let gapXS: CGFloat = 4

    /// 8pt — standard tight
    static let gapS: CGFloat = 8

    /// 12pt — default between related elements
    static let gap: CGFloat = 12

    /// 16pt — between sections within a card
    static let gapM: CGFloat = 16

    /// 20pt — between major sections
    static let gapL: CGFloat = 20

    /// 28pt — generous breathing room
    static let gapXL: CGFloat = 28

    // MARK: - Layout

    /// 24pt — screen horizontal padding (matches Apple navigation)
    static let screenPadding: CGFloat = 24

    /// 20pt — card internal padding
    static let cardPadding: CGFloat = 20

    /// 32pt — safe bottom padding for primary action zones
    static let bottomSafe: CGFloat = 32
}
