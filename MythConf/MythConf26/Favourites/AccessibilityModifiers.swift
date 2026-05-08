//
//  AccessibilityModifiers.swift
//  IOSDevuk26
//

import SwiftUI

/// Applies `.foregroundStyle(.secondary)` for normal viewing but switches to
/// `.primary` when the user has enabled Increase Contrast. Many of the
/// secondary captions in the app sit on tinted backgrounds where the system
/// secondary colour falls below the WCAG 4.5:1 contrast threshold.
private struct ContrastAdaptiveSecondary: ViewModifier {
    @Environment(\.colorSchemeContrast) private var contrast

    func body(content: Content) -> some View {
        content.foregroundStyle(contrast == .increased ? .primary : .secondary)
    }
}

extension View {
    /// Use in place of `.foregroundStyle(.secondary)` on captions/subtitles
    /// that sit on tinted backgrounds. Preserves the visual hierarchy in
    /// default contrast and lifts the colour to primary when the user has
    /// switched on Increase Contrast.
    func contrastAdaptiveSecondary() -> some View {
        modifier(ContrastAdaptiveSecondary())
    }
}
