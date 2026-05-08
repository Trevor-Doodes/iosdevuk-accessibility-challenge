//
//  HomeView.swift
//  IOSDevuk26
//
//  Created by Chris Price on 25/03/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("Programme", systemImage: "calendar") {
                ProgrammeView()
                    .accessibilityInputLabels(["Programme", "Schedule", "Sessions"])
            }
            Tab("Speakers", systemImage: "person.2") {
                SpeakersView()
                    .accessibilityInputLabels(["Speakers", "People"])
            }
            Tab("Locations", systemImage: "map") {
                LocationsView()
                    .accessibilityInputLabels(["Locations", "Map", "Venues"])
            }
            Tab("My Schedule", systemImage: "star") {
                MyScheduleView()
                    .accessibilityInputLabels(["My Schedule", "Favourites", "Saved"])
            }
        }
    }

}

#Preview {
    HomeView()
}
