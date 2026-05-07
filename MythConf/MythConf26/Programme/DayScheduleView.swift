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

    private var favouriteTalkIDs: [UUID] {
        sessions.flatMap { session in
            session.contentIDs.filter { viewModel.isFavourite(talk: viewModel.talkFrom(talkID: $0)) }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(sessions) { session in
                    if session.containsTalk {
                        ParallelSessionsRowView(session: session, rotorNamespace: rotorNamespace)
                    } else {
                        BreakRowView(session: session)
                    }
                    Divider()
                        .accessibilityHidden(true)
                }
            }
        }
        .accessibilityRotor("Favourite Sessions") {
            ForEach(favouriteTalkIDs, id: \.self) { talkID in
                AccessibilityRotorEntry(viewModel.talkTitleFrom(talkID: talkID), talkID, in: rotorNamespace)
            }
        }
    }
}
