//
//  ParallelSessionsRowView.swift
//  IOSDevuk26
//

import SwiftUI

/// A row displaying two parallel sessions side by side.
struct ParallelSessionsRowView: View {
    let session: Session
    let rotorNamespace: Namespace.ID

    var body: some View {
        HStack(alignment: .top) {
            TimeColumnView(startTime: session.startTimeText, endTime: session.endTimeText)

            HStack(alignment: .top) {
                ForEach(session.contentIDs, id: \.self) { talkID in
                    ParallelTalkCardView(talkID: talkID, session: session, rotorNamespace: rotorNamespace)
                }
            }
        }
        .padding()
    }
}
