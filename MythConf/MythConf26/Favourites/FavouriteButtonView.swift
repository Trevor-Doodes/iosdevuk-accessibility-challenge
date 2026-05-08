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

    var body: some View {
        Button {
            if viewModel.isFavourite(talk: talk) {
                viewModel.removeFavourite(talk: talk)
            } else {
                viewModel.addFavourite(talk: talk)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    UIAccessibility.post(
                        notification: .announcement,
                        argument: NSAttributedString(
                            string: "Added to My Schedule.",
                            attributes: [.accessibilitySpeechQueueAnnouncement: true]
                        )
                    )
                }
            }
        } label: {
            Image(systemName: viewModel.isFavourite(talk: talk) ? "star.fill" : "star")
                .foregroundStyle(viewModel.isFavourite(talk: talk) ? .yellow : .secondary)
        }
        .frame(minWidth: 44, minHeight: 44)
        .accessibilityLabel(viewModel.isFavourite(talk: talk) ? "Remove from favourites" : "Add to favourites")
        .sensoryFeedback(.success, trigger: viewModel.isFavourite(talk: talk))
    }
}
