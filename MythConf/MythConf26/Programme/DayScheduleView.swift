//
//  DayScheduleView.swift
//  IOSDevuk26
//

import SwiftUI

/// A scrollable list of all time slots for a single conference day.
struct DayScheduleView: View {
    @Environment(ViewModel.self) private var viewModel
    @Namespace private var rotorNamespace
    let sessions: [Session]

    var body: some View {
        // Computed inside body so @Observable tracking registers favouriteIds correctly
        let sessionsWithFavourites = sessions.filter { session in
            session.containsTalk && session.contentIDs.contains {
                viewModel.isFavourite(talk: viewModel.talkFrom(talkID: $0))
            }
        }

        ScrollView {
            VStack(spacing: 0) {
                ForEach(sessions) { session in
                    if session.containsTalk {
                        ParallelSessionsRowView(session: session)
                            .accessibilityRotorEntry(id: session.id, in: rotorNamespace)
                    } else {
                        BreakRowView(session: session)
                    }
                    Divider()
                        .accessibilityHidden(true)
                }
            }
        }
        .accessibilityRotor("Favourite Sessions") {
            ForEach(sessionsWithFavourites) { session in
                AccessibilityRotorEntry(rotorLabel(for: session), session.id, in: rotorNamespace)
            }
        }
    }

    private func rotorLabel(for session: Session) -> String {
        let firstFavouriteTitle = session.contentIDs
            .first { viewModel.isFavourite(talk: viewModel.talkFrom(talkID: $0)) }
            .map { viewModel.talkTitleFrom(talkID: $0) }
        return firstFavouriteTitle.map { "\(session.startTimeText): \($0)" } ?? session.startTimeText
    }
}
