//
//  DayViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

@MainActor @Observable
final class DayViewModel {
    let title: String
    let events: [Event]

    var timeSpent: TimeInterval
    var timeSpentSummary: String

    init(title: String, events: [Event]) {
        self.title = title
        self.events = events

        let timeSpent = Self.timeSpent(for: events)
        self.timeSpent = timeSpent
        self.timeSpentSummary = Self.timeSpentSummary(timeSpent: timeSpent)
    }

    private static func timeSpent(for events: [Event]) -> TimeInterval {
        events.filter { $0.takesTime }
            .compactMap { $0.endDate.timeIntervalSince($0.startDate) }
            .reduce(0, { $0 + $1 })
    }

    private static func timeSpentSummary(timeSpent: TimeInterval) -> String {
        String(localized: "\(TimeFormatter.string(fromSeconds: timeSpent)) spent in meetings.")
    }
}
