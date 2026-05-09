//
//  MyScheduleView.swift
//  IOSDevuk26
//

import SwiftUI

struct MyScheduleView: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favouriteIds.isEmpty {
                    ContentUnavailableView(
                        "No Favourites Yet",
                        systemImage: "star",
                        description: Text("Tap the star on any session in the Programme to save it here.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                            ForEach(viewModel.favouritesBySession.indices, id: \.self) { dayIndex in
                                let daySessions = viewModel.favouritesBySession[dayIndex]
                                if daySessions.first?.sessionType != .dummy {
                                    Section {
                                        FavouriteDaySessionList(sessions: daySessions)
                                    } header: {
                                        Text(dayHeader(for: daySessions))
                                            .font(.headline)
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(.regularMaterial)
                                            .accessibilityAddTraits(.isHeader)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Schedule")
            .conferenceNavigationDestinations()
        }
    }

    private func dayHeader(for sessions: [Session]) -> String {
        guard let first = sessions.first else { return "" }
        return first.startTime.formatted(.dateTime.weekday(.wide).day().month(.wide))
    }
}

/// Renders the parallel-session rows for a single day. Extracted into its
/// own `View` so its `body` is unambiguously evaluated in SwiftUI's
/// `ViewBuilder` context — inlining the ForEach inside `Section { ... }`
/// caused Xcode 16 to resolve it to `MapContentBuilder`.
private struct FavouriteDaySessionList: View {
    let sessions: [Session]

    var body: some View {
        ForEach(sessions) { session in
            ParallelSessionsRowView(session: session)
            Divider()
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    MyScheduleView()
        .environment(ViewModel())
}
