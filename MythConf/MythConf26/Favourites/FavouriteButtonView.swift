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
    /// When non-nil, overrides the displayed state so the label stays
    /// frozen during the announcement sequence, preventing VoiceOver from
    /// auto-announcing the state change before our custom message finishes.
    @State private var labelOverride: Bool? = nil

    private var isFavourite: Bool { viewModel.isFavourite(talk: talk) }
    /// Drives the accessibility label only — frozen during the announcement
    /// window so VoiceOver does not auto-read the new label mid-announcement.
    private var labelIsFavourite: Bool { labelOverride ?? isFavourite }

    var body: some View {
        Button {
            let wasAlreadyFavourite = isFavourite

            // Freeze the label at the pre-tap state so VoiceOver does not
            // auto-announce the change while our custom message is queued.
            labelOverride = wasAlreadyFavourite

            if wasAlreadyFavourite {
                viewModel.removeFavourite(talk: talk)
                AccessibilityAnnouncer.shared.announce("Removed from favourites.")
            } else {
                viewModel.addFavourite(talk: talk)
                AccessibilityAnnouncer.shared.announce(
                    "Added to favourites. Switch to My Schedule to see all your saved sessions."
                )
            }

            // Release the freeze after the announcement (plus retry window) has
            // had time to play. If VoiceOver is still focused on this button it
            // will then naturally re-read the element with its updated label.
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                labelOverride = nil
            }
        } label: {
            Image(systemName: isFavourite ? "star.fill" : "star")
                .foregroundStyle(isFavourite ? .yellow : .secondary)
        }
        .frame(minWidth: 44, minHeight: 44)
        .accessibilityLabel(labelIsFavourite ? "Remove from favourites" : "Add to favourites")
        .sensoryFeedback(.success, trigger: isFavourite)
    }
}
