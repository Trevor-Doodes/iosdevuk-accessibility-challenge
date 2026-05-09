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
    /// a two-digit zero-padded hour ("09:30") which speech engines often
    /// read with a pause between hour and minutes ("zero nine, thirty").
    /// The shortened locale time format ("9:30 am") is read naturally.
    var startTimeAccessibilityText: String {
        startTime.formatted(date: .omitted, time: .shortened)
    }

    var endTimeAccessibilityText: String {
        endTime.formatted(date: .omitted, time: .shortened)
    }

    var timeRange: String { "\(startTimeText) – \(endTimeText)" }
}

