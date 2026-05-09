//
//  Session.swift
//  TalkGenerator
//
//  Created by Chris Price on 29/06/2022.
//

import Foundation

struct Session: Codable, Identifiable, Hashable {
    var id = UUID()
    let startTime: Date
    let endTime: Date
    let sessionType: SessionType
    let sessionCount: Int
    var contentIDs: [UUID] = []

    var dayAndDate: String {
        startTime.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
    }

    var containsTalk: Bool {
        return sessionType == .talk || sessionType == .workshop
    }

    var startTimeText: String {
        startTime.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
    }

    var endTimeText: String {
        endTime.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
    }

    /// Time string optimised for VoiceOver. The visible `startTimeText` uses
    /// `09:30`; speech engines treat the colon as a punctuation break and
    /// pause between the hour and minutes ("nine, thirty"). Stripping the
    /// colon to a plain space ("9 30 am") makes VoiceOver read the time
    /// as a flowing phrase ("nine thirty AM").
    var startTimeAccessibilityText: String {
        startTime
            .formatted(date: .omitted, time: .shortened)
            .replacingOccurrences(of: ":", with: " ")
    }

    var endTimeAccessibilityText: String {
        endTime
            .formatted(date: .omitted, time: .shortened)
            .replacingOccurrences(of: ":", with: " ")
    }

    var timeRange: String { "\(startTimeText) – \(endTimeText)" }
}

