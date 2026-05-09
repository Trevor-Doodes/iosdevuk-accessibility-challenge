//
//  DayScheduleView.swift
//  IOSDevuk26
//

import SwiftUI

/// A scrollable list of all time slots for a single conference day.
struct DayScheduleView: View {
    let sessions: [Session]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(sessions) { session in
                    // Group wrap disambiguates SwiftUI's ForEach overload
                    // resolution under Xcode 16 SDKs where a multi-child
                    // closure body otherwise resolves to MapContentBuilder.
                    Group {
                        if session.containsTalk {
                            ParallelSessionsRowView(session: session)
                        } else {
                            BreakRowView(session: session)
                        }
                        Divider()
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }
}
