//
//  MythConf26Tests.swift
//  MythConf26Tests
//

import Testing
@testable import MythConf26

struct MythConf26Tests {

    /// `isFavourite` should return `false` for a talk that has never been
    /// added to the user's favourites.
    @Test func newTalkIsNotFavouriteByDefault() async throws {
        let viewModel = ViewModel()
        let firstTalk = try #require(viewModel.confData.talks.first)
        viewModel.removeFavourite(talk: firstTalk)

        #expect(viewModel.isFavourite(talk: firstTalk) == false)
    }

    /// Adding a talk should make `isFavourite` return `true` and the talk's
    /// ID should appear in `favouriteIds`.
    @Test func addingATalkMakesItFavourite() async throws {
        let viewModel = ViewModel()
        let talk = try #require(viewModel.confData.talks.first)
        viewModel.removeFavourite(talk: talk)

        viewModel.addFavourite(talk: talk)

        #expect(viewModel.isFavourite(talk: talk) == true)
        #expect(viewModel.favouriteIds.contains(talk.id))

        viewModel.removeFavourite(talk: talk)
    }

    /// Removing a talk should reverse `addFavourite`, leaving `isFavourite`
    /// false again.
    @Test func removingAFavouriteClearsIt() async throws {
        let viewModel = ViewModel()
        let talk = try #require(viewModel.confData.talks.first)
        viewModel.addFavourite(talk: talk)

        viewModel.removeFavourite(talk: talk)

        #expect(viewModel.isFavourite(talk: talk) == false)
        #expect(viewModel.favouriteIds.contains(talk.id) == false)
    }

    /// `talkTitleFrom(talkID:)` and `talkFrom(talkID:)` must agree — both
    /// underpin the talk card's accessibility label.
    @Test func talkLookupsAreConsistent() async throws {
        let viewModel = ViewModel()
        let talk = try #require(viewModel.confData.talks.first)

        #expect(viewModel.talkTitleFrom(talkID: talk.id) == talk.talkTitle)
        #expect(viewModel.talkFrom(talkID: talk.id).id == talk.id)
    }

    /// Every talk must resolve to a non-empty location name. The talk card's
    /// accessibility label includes the location, so a missing value would
    /// produce a malformed VoiceOver announcement.
    @Test func everyTalkHasANonEmptyLocationName() async throws {
        let viewModel = ViewModel()

        for talk in viewModel.confData.talks {
            let name = viewModel.locationNameFrom(talkID: talk.id)
            #expect(!name.isEmpty, "Talk '\(talk.talkTitle)' has empty location name")
        }
    }
}
