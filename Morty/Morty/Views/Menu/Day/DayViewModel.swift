//
//  DayViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Factory
import Foundation
import SwiftUI

@MainActor @Observable
final class DayViewModel {
    let title: String
    let events: [Event]
    let reminders: [Reminder]

    var timeSpent: TimeInterval
    var timeSpentSummary: String

    var copyStandupEnabled: Bool

    private let defaultService = Container.shared.defaultsService()

    var standupText: String {
        var standupEvents = events

        if defaultService.filterOnePersonMeetings {
            standupEvents = standupEvents.filter { $0.type == .meeting || $0.type == .allDay }
        }

        let standup = standupEvents
            .compactMap { $0.standupText }
            .joined(separator: "\n")

        var timeReport: String?
        if timeSpent > 0 {
            timeReport = "🕓 \(TimeFormatter.string(fromSeconds: timeSpent)) spent in meetings"
        }

        let tasks = reminders
            .filter { !$0.isCompleted }
            .map { $0.standupText }
            .joined(separator: "\n\n")

        let retVal = [standup, timeReport, tasks]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")

        return retVal
    }

    init(title: String, events: [Event], reminders: [Reminder]) {
        self.title = title
        self.events = events
        self.reminders = reminders

        let timeSpent = Self.timeSpent(for: events)
        self.timeSpent = timeSpent
        self.timeSpentSummary = Self.timeSpentSummary(timeSpent: timeSpent)

        self.copyStandupEnabled = !events.isEmpty || !reminders.isEmpty
    }

    func copyStandupButtonPressed() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(standupText, forType: .string)
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
