//
//  MythConf26Tests.swift
//  MythConf26Tests
//

import Foundation
import Testing
@testable import MythConf26

/// Tests around the favourites cycle. The favourite button's accessibility
/// label, hint, `.isSelected` trait, and the announcement it triggers all
/// derive from `ViewModel.isFavourite`, so the round-trip integrity of these
/// methods is what makes the VoiceOver experience correct.
///
/// Serialised because favourites are persisted to a shared `favourites.json`
/// in the test host's Documents directory; parallel tests would race on the
/// underlying file.
@Suite(.serialized)
struct FavouritesTests {
    let viewModel: ViewModel
    let talk: Talk

    init() throws {
        viewModel = ViewModel()
        talk = try #require(viewModel.confData.talks.first)
        // Start each test from a known clean state.
        viewModel.removeFavourite(talk: talk)
    }

    @Test func newTalkIsNotFavouriteByDefault() {
        #expect(viewModel.isFavourite(talk: talk) == false)
    }

    @Test func addingATalkMakesItFavourite() {
        viewModel.addFavourite(talk: talk)

        #expect(viewModel.isFavourite(talk: talk))
        #expect(viewModel.favouriteIds.contains(talk.id))
    }

    @Test func removingAFavouriteClearsIt() {
        viewModel.addFavourite(talk: talk)

        viewModel.removeFavourite(talk: talk)

        #expect(viewModel.isFavourite(talk: talk) == false)
        #expect(viewModel.favouriteIds.contains(talk.id) == false)
    }

    /// Removing a talk that was never a favourite must be a no-op. The
    /// favourite button does not check the current state before calling
    /// `removeFavourite`, so a defensive remove must not crash or corrupt
    /// state.
    @Test func removingANonFavouriteIsHarmless() {
        viewModel.removeFavourite(talk: talk)

        #expect(viewModel.isFavourite(talk: talk) == false)
    }

    /// Two talks must be tracked independently — adding one must not flip
    /// the other.
    @Test func favouritesAreTrackedPerTalk() throws {
        let other = try #require(viewModel.confData.talks.dropFirst().first)
        viewModel.removeFavourite(talk: other)

        viewModel.addFavourite(talk: talk)

        #expect(viewModel.isFavourite(talk: talk))
        #expect(viewModel.isFavourite(talk: other) == false)

        viewModel.removeFavourite(talk: talk)
    }

    /// `favouritesBySession` powers My Schedule. After adding a talk, the
    /// flattened list of session content IDs across all days must contain
    /// that talk.
    @Test func favouritesBySessionReflectsAddedTalk() {
        viewModel.addFavourite(talk: talk)

        let allFavouriteContentIDs = viewModel.favouritesBySession
            .flatMap { $0 }
            .filter { $0.sessionType != .dummy }
            .flatMap(\.contentIDs)

        #expect(allFavouriteContentIDs.contains(talk.id))
    }
}

/// Tests for the lookup helpers on `ViewModel`. The talk card's accessibility
/// label is composed from these — if any returns inconsistent or empty data,
/// VoiceOver hears a malformed announcement.
struct LookupTests {
    let viewModel = ViewModel()

    /// `talkTitleFrom(talkID:)` and `talkFrom(talkID:)` must agree.
    @Test func talkLookupsAreConsistent() throws {
        let talk = try #require(viewModel.confData.talks.first)

        #expect(viewModel.talkTitleFrom(talkID: talk.id) == talk.talkTitle)
        #expect(viewModel.talkFrom(talkID: talk.id).id == talk.id)
    }

    /// Title → ID → title must round-trip cleanly. This guards against
    /// duplicate titles silently breaking the input-label flow used by
    /// Voice Control.
    @Test func talkTitleRoundTrip() throws {
        let talk = try #require(viewModel.confData.talks.first)

        let resolved = viewModel.talkUUIDFrom(talkTitle: talk.talkTitle)

        #expect(resolved == talk.id)
        #expect(viewModel.talkTitleFrom(talkID: resolved) == talk.talkTitle)
    }

    /// Every talk must resolve to a non-empty location name. The talk
    /// card's accessibility label trails with the location, so a missing
    /// value would produce a sentence ending mid-clause.
    @Test func everyTalkHasANonEmptyLocationName() {
        for talk in viewModel.confData.talks {
            let name = viewModel.locationNameFrom(talkID: talk.id)
            #expect(!name.isEmpty, "Talk '\(talk.talkTitle)' has empty location name")
        }
    }

    /// `speakersFrom` must return a non-empty string for every talk so the
    /// card's "by [speakers]" clause is never blank. Talks with missing or
    /// unknown speaker IDs fall back to a placeholder rather than crashing.
    @Test func everyTalkHasASpeakerName() {
        for talk in viewModel.confData.talks {
            let speakers = viewModel.speakersFrom(talkID: talk.id)
            #expect(!speakers.isEmpty, "Talk '\(talk.talkTitle)' produced empty speaker name string")
        }
    }

    /// Talks with multiple speakers are joined by `formatted(.list(type:.and))`
    /// — "A and B" or "A, B, and C" — so VoiceOver doesn't run names
    /// together. The current conf data has no multi-speaker talks, so this
    /// test verifies the formatter contract directly with synthetic input
    /// to guard the behaviour for when the data does include co-presented
    /// talks.
    @Test func multipleSpeakersAreJoinedNaturally() {
        let two = ["Ada Lovelace", "Alan Turing"].formatted(.list(type: .and))
        let three = ["Ada Lovelace", "Alan Turing", "Grace Hopper"].formatted(.list(type: .and))

        #expect(two.contains(" and "), "Two-speaker join should contain ' and ': got '\(two)'")
        #expect(three.contains(" and "), "Three-speaker join should contain ' and ': got '\(three)'")
    }

}
