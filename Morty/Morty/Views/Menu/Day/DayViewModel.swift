//
//  DayViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

@MainActor @Observable
final class DayViewModel {
    let date: Date
    let events: [Event]

    var title: String

    var timeSpent: TimeInterval
    var timeSpentSummary: String

    init(date: Date, events: [Event]) {
        self.date = date
        self.events = events

        self.title = Self.title(for: date)

        let timeSpent = Self.timeSpent(for: events)
        self.timeSpent = timeSpent
        self.timeSpentSummary = Self.timeSpentSummary(timeSpent: timeSpent)
    }

    private static func title(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return String(localized: "today").localizedCapitalized
        }

        let formatStyle = Date.RelativeFormatStyle(presentation: .named, unitsStyle: .wide)
        return formatStyle.format(date).localizedCapitalized
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
