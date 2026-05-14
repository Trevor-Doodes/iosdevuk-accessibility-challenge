//
//  SocialLinksView.swift
//  IOSDevuk26
//

import SwiftUI

/// A grid of tappable social/web links for a speaker.
///
/// The bundled conference data packs multiple URLs into a single
/// `SocialItem.socialLink` separated by newlines (e.g.
/// `"https://example.com\nhttps://github.com/foo\n"`). `URL(string:)` is
/// lenient enough to accept the whole string, but the resulting URL has
/// embedded newlines and the system fails to open it — leaving Voice
/// Control commands like "Open GitHub" producing no result. This view
/// splits each `socialLink` into its constituent URLs and renders one
/// `Link` per chunk, each with a host-derived label so VoiceOver and
/// Voice Control can address them individually.
///
/// Each link is rendered as an icon-only target with an 88×88pt hit area
/// — double the HIG minimum — laid out in an adaptive grid so the
/// generous touch targets wrap cleanly on narrower devices. The visible
/// icon is small and centred; the surrounding 88×88pt rectangle catches
/// taps for users with reduced dexterity. The friendly host-derived name
/// ("GitHub", "Website", etc.) is exposed via `.accessibilityLabel` so
/// VoiceOver and Voice Control announce and target each profile
/// independently.
struct SocialLinksView: View {
    let social: [SocialItem]

    private let columns = [GridItem(.adaptive(minimum: 88), spacing: 0)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
            ForEach(Array(expandedLinks.enumerated()), id: \.offset) { _, link in
                Link(destination: link.url) {
                    Image(systemName: link.symbolName)
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .frame(width: 88, height: 88)
                        .contentShape(.rect)
                }
                .accessibilityLabel(link.displayLabel)
                .accessibilityHint("Opens in browser")
                .accessibilityInputLabels([link.displayLabel, "\(link.displayLabel) profile"])
            }
        }
    }

    private var expandedLinks: [ResolvedLink] {
        social.flatMap { item -> [ResolvedLink] in
            item.socialLink
                .split(separator: "\n", omittingEmptySubsequences: true)
                .map { String($0).trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
                .compactMap { chunk -> ResolvedLink? in
                    guard let url = URL(string: chunk), url.scheme != nil else { return nil }
                    return ResolvedLink(
                        url: url,
                        displayLabel: Self.displayLabel(for: url, fallbackType: item.socialType),
                        symbolName: Self.symbolName(for: url, fallbackType: item.socialType)
                    )
                }
        }
    }

    fileprivate struct ResolvedLink {
        let url: URL
        let displayLabel: String
        let symbolName: String
    }

    /// Picks a friendly label from a URL's host. Falls back to the
    /// `SocialItem.socialType` when the host doesn't match a known
    /// network, with the generic web/blog/`www` bucket reading as
    /// "Website" rather than the raw token so VoiceOver doesn't speak
    /// "Www" character-by-character.
    static func displayLabel(for url: URL, fallbackType: String) -> String {
        let host = (url.host ?? "").lowercased()
        if host.contains("github") { return "GitHub" }
        if host.contains("linkedin") { return "LinkedIn" }
        if host.contains("mastodon") || host.hasSuffix("mas.to") || host.hasPrefix("mstdn.") || host.hasPrefix("mas.") { return "Mastodon" }
        if host.contains("bsky.app") { return "Bluesky" }
        if host.contains("twitter.com") || host == "x.com" || host.hasSuffix(".x.com") { return "Twitter / X" }

        let lower = fallbackType.lowercased()
        if ["www", "web", "website", "blog"].contains(lower) { return "Website" }
        return fallbackType.capitalized
    }

    /// Picks an SF Symbol from a URL's host. Falls back to the legacy
    /// `iconName(for:)` mapping driven by `SocialItem.socialType` when no
    /// host match exists.
    static func symbolName(for url: URL, fallbackType: String) -> String {
        let host = (url.host ?? "").lowercased()
        if host.contains("github") { return "chevron.left.forwardslash.chevron.right" }
        if host.contains("linkedin") { return "person.crop.square" }
        if host.contains("mastodon") || host.hasSuffix("mas.to") || host.hasPrefix("mstdn.") || host.hasPrefix("mas.") { return "at.badge.plus" }
        if host.contains("bsky.app") { return "cloud" }
        if host.contains("twitter.com") || host == "x.com" || host.hasSuffix(".x.com") { return "at" }
        return Self.fallbackSymbolName(for: fallbackType)
    }

    private static func fallbackSymbolName(for type: String) -> String {
        switch type.lowercased() {
        case "twitter", "x": return "at"
        case "mastodon": return "at.badge.plus"
        case "github": return "chevron.left.forwardslash.chevron.right"
        case "linkedin": return "person.crop.square"
        case "website", "web", "blog", "www": return "globe"
        default: return "link"
        }
    }
}
