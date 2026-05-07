//
//  BreakRowView.swift
//  IOSDevuk26
//

import SwiftUI

/// A full-width row for non-session slots such as breaks, lunch, and social events.
struct BreakRowView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    let session: Session

    private var backgroundOpacity: Double { (contrast == .increased || reduceTransparency) ? 0.25 : 0.12 }

    var body: some View {
        HStack {
            TimeColumnView(startTime: session.startTimeText, endTime: session.endTimeText)

            VStack(alignment: .leading) {
                Text(session.sessionType.displayName)
                    .italic()
                    .foregroundStyle(.primary)
                if let talkID = session.contentIDs.first {
                    Text(viewModel.locationNameFrom(talkID: talkID))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(session.sessionType.color.opacity(backgroundOpacity))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(session.sessionType.displayName), \(session.startTimeText) to \(session.endTimeText)")
    }
}
