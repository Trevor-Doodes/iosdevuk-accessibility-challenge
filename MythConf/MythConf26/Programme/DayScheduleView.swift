//
//  DayScheduleView.swift
//  IOSDevuk26
//

import SwiftUI

private struct SessionRotorEntry: Identifiable {
    let id: UUID
    let label: String
}

/// A scrollable list of all time slots for a single conference day.
struct DayScheduleView: View {
    @Environment(ViewModel.self) private var viewModel
    let sessions: [Session]

    var body: some View {
        // Direct access to favouriteIds ensures @Observable tracks this property
        let favouriteIds = viewModel.favouriteIds

        let rotorEntries: [SessionRotorEntry] = sessions.compactMap { session in
            guard session.containsTalk else { return nil }
            guard let firstFavID = session.contentIDs.first(where: { favouriteIds.contains($0) }) else { return nil }
            let label = "\(session.startTimeText): \(viewModel.talkTitleFrom(talkID: firstFavID))"
            return SessionRotorEntry(id: session.id, label: label)
        }

        ScrollView {
            VStack(spacing: 0) {
                ForEach(sessions) { session in
                    if session.containsTalk {
                        ParallelSessionsRowView(session: session)
                            .id(session.id)
                    } else {
                        BreakRowView(session: session)
                    }
                    Divider()
                        .accessibilityHidden(true)
                }
            }
        }
        .accessibilityRotor("Favourite Sessions", entries: rotorEntries, entryLabel: \.label)
    }
}
