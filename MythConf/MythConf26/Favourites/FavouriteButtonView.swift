//
//  FavouriteButtonView.swift
//  IOSDevuk26
//

import SwiftUI
import UIKit

/// A button that toggles a talk as a favourite.
struct FavouriteButtonView: View {
    @Environment(ViewModel.self) private var viewModel
    let talk: Talk
    /// When non-nil, overrides the displayed accessibility state so the label
    /// and selected trait stay frozen during the announcement sequence,
    /// preventing VoiceOver from auto-announcing the state change before our
    /// custom message finishes.
    @State private var labelOverride: Bool? = nil
    @AppStorage("hasSeenFavouritesHint") private var hasSeenFavouritesHint = false

    private var isFavourite: Bool { viewModel.isFavourite(talk: talk) }
    /// Drives the accessibility label and selected trait — frozen during the
    /// announcement window so VoiceOver does not auto-read the new state
    /// mid-announcement.
    private var labelIsFavourite: Bool { labelOverride ?? isFavourite }

    var body: some View {
        Button {
            let wasAlreadyFavourite = isFavourite

            // Freeze the accessibility state at the pre-tap value so VoiceOver
            // does not auto-announce the change while our custom message is
            // queued.
            labelOverride = wasAlreadyFavourite

            if wasAlreadyFavourite {
                viewModel.removeFavourite(talk: talk)
                AccessibilityAnnouncer.shared.announce("Removed from favourites.")
            } else {
                viewModel.addFavourite(talk: talk)
                if hasSeenFavouritesHint {
                    AccessibilityAnnouncer.shared.announce("Added to favourites.")
                } else {
                    AccessibilityAnnouncer.shared.announce(
                        "Added to favourites. Switch to My Schedule to see all your saved sessions."
                    )
                    hasSeenFavouritesHint = true
                }
            }

            // Release the freeze after the announcement (plus retry window)
            // has had time to play. If VoiceOver is still focused on this
            // button it will then naturally re-read the element with its
            // updated label and selected state.
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                labelOverride = nil
            }
        } label: {
            Image(systemName: isFavourite ? "star.fill" : "star")
                .font(.title3)
                .foregroundStyle(isFavourite ? .orange : .primary)
                .symbolEffect(.bounce, value: isFavourite)
                .padding(8)
                // Material backing keeps the star legible against tinted
                // session-type card backgrounds (especially the yellow
                // lightning-talks tint where a yellow star would vanish).
                .background(Circle().fill(.regularMaterial))
        }
        .frame(minWidth: 88, minHeight: 88, alignment: .bottomTrailing)
        .contentShape(Rectangle())
        .accessibilityLabel(labelIsFavourite ? "Remove from favourites" : "Add to favourites")
        .accessibilityHint(labelIsFavourite ? "Removes this session from your saved schedule" : "Adds this session to your saved schedule")
        .accessibilityAddTraits(labelIsFavourite ? .isSelected : [])
        .accessibilityInputLabels(["Favourite", "Star", "Save"])
        .sensoryFeedback(trigger: isFavourite) { _, newValue in
            newValue ? .success : .impact(weight: .light)
        }
    }
}
