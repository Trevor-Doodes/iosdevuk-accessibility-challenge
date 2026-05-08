//
//  ParallelTalkCardView.swift
//  IOSDevuk26
//

import SwiftUI

/// A card showing a single talk within a parallel-session slot.
struct ParallelTalkCardView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    let talkID: UUID
    let session: Session
    /// Reserved bottom space inside the card so the favourite star icon
    /// doesn't sit on top of the location text. Scales with Dynamic Type so
    /// the icon stays clear at larger text sizes.
    @ScaledMetric(relativeTo: .caption) private var starReservedHeight: CGFloat = 28

    private var cardOpacity: Double { (contrast == .increased || reduceTransparency) ? 0.25 : 0.1 }

    var body: some View {
        NavigationLink(value: TalkReference(talkID: talkID, session: session)) {
            VStack(alignment: .leading, spacing: 0) {
                session.sessionType.color
                    .frame(height: 4)
                    .accessibilityHidden(true)

                HStack(alignment: .top) {
                    TimeColumnView(startTime: session.startTimeText, endTime: session.endTimeText)

                    VStack(alignment: .leading) {
                        Text(viewModel.talkTitleFrom(talkID: talkID))
                            .bold()
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Text(viewModel.speakersFrom(talkID: talkID))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                        Text(viewModel.locationNameFrom(talkID: talkID))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        // Space reserved so the overlay star icon doesn't sit on
                        // top of the location text. The button's invisible hit
                        // area extends further up but doesn't push layout.
                        Color.clear.frame(height: starReservedHeight)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(session.sessionType.color.opacity(cardOpacity), in: .rect(cornerRadius: 10))
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                (contrast == .increased || reduceTransparency) ?
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(session.sessionType.color, lineWidth: 1.5)
                        .allowsHitTesting(false) : nil
            )
        }
        .accessibilityLabel("\(session.sessionType.displayName) from \(session.startTimeText) to \(session.endTimeText): \(viewModel.talkTitleFrom(talkID: talkID)), by \(viewModel.speakersFrom(talkID: talkID)), \(viewModel.locationNameFrom(talkID: talkID))")
        .accessibilityInputLabels([viewModel.talkTitleFrom(talkID: talkID)])
        .buttonStyle(.plain)
        .overlay(alignment: .bottomTrailing) {
            FavouriteButtonView(talk: viewModel.talkFrom(talkID: talkID))
                .padding(8)
        }
    }
}
