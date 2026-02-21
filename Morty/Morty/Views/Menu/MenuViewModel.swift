//
//  MenuViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import Combine
import EventKit
import Factory
import Foundation
import SwiftUI

@Observable @MainActor
final class MenuViewModel {
    var previousDayViewModel: DayViewModel
    var currentDayViewModel: DayViewModel
    var nextDayViewModel: DayViewModel

    private let eventService = Container.shared.eventService()
    private var cancellables = Set<AnyCancellable>()

    var fullStandupText: String {
        let howAreYouFeeling = "1️⃣ How are you feeling? 🌡️"

        var previousReport = "2️⃣ What have you worked on since your last report? 📋"
        previousReport.append("\n")
        previousReport.append(previousDayViewModel.title)
        previousReport.append("\n")
        previousReport.append(previousDayViewModel.standupText)

        var todayReport = "3️⃣ What will you do today? 📋"
        todayReport.append("\n")
        todayReport.append(currentDayViewModel.standupText)

        return [howAreYouFeeling, previousReport, todayReport]
            .joined(separator: "\n\n")
    }

    init() {
        let previousDayTitle = String(localized: "previously").localizedCapitalized
        previousDayViewModel = DayViewModel(title: previousDayTitle, events: [], reminders: [])

        let todayTitle = String(localized: "today").localizedCapitalized
        currentDayViewModel = DayViewModel(title: todayTitle, events: [], reminders: [])

        let nextDayTitle = String(localized: "next").localizedCapitalized
        nextDayViewModel = DayViewModel(title: nextDayTitle, events: [], reminders: [])

        setupUpdateEventsBindings()
    }

    func update(events: [Event], reminders: [Reminder]) {
        // Previous events
        if let previousDay = Self.nextNonWeekendDay(since: Date(), isForward: false) {
            let previousDayEvents = events
                .filter { Calendar.current.isDate($0.startDate, inSameDayAs: previousDay) }
                .sorted { lhs, rhs in
                    lhs.startDate < rhs.startDate
                }
            let previousDayTitle = Self.title(for: previousDay)
            previousDayViewModel = DayViewModel(title: previousDayTitle, events: previousDayEvents, reminders: [])
        }

        // Today events
        let todayEvents = events
            .filter { Calendar.current.isDateInToday($0.startDate) }
            .sorted { lhs, rhs in
                lhs.startDate < rhs.startDate
            }

        let todayReminders = reminders.filter { !$0.isCompleted }

        let todayTitle = String(localized: "today").localizedCapitalized
        currentDayViewModel = DayViewModel(
            title: todayTitle,
            events: todayEvents,
            reminders: todayReminders
        )

        // Next events
        if let nextDay = Self.nextNonWeekendDay(since: Date(), isForward: true) {
            let nextDayEvents = events
                .filter { Calendar.current.isDate($0.startDate, inSameDayAs: nextDay) }
                .sorted { lhs, rhs in
                    lhs.startDate < rhs.startDate
                }
            let nextDayTitle = Self.title(for: nextDay)
            nextDayViewModel = DayViewModel(title: nextDayTitle, events: nextDayEvents, reminders: [])
        }
    }

    func copyFullStandupButtonPressed() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(fullStandupText, forType: .string)
    }

    private func setupUpdateEventsBindings() {
        eventService
            .eventsFetched
            .receive(on: RunLoop.main)
            .sink { [weak self] values in
                self?.update(events: values.0, reminders: values.1)
            }
            .store(in: &cancellables)
    }

    private static func nextNonWeekendDay(since date: Date, isForward: Bool) -> Date? {
        let direction = isForward ? 1 : -1
        var current = Calendar.current.startOfDay(for: date)

        repeat {
            guard let previous = Calendar.current.date(
                byAdding: .day,
                value: direction,
                to: current
            ) else {
                return nil
            }
            current = previous
        } while Calendar.current.isDateInWeekend(current)

        return current
    }

    private static func title(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return String(localized: "today").localizedCapitalized
        }

        if Calendar.current.isDateInYesterday(date) {
            return String(localized: "yesterday").localizedCapitalized
        }

        if Calendar.current.isDateInTomorrow(date) {
            return String(localized: "tomorrow").localizedCapitalized
        }

        return date.weekday
    }
}
