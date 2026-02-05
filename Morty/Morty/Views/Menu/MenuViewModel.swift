//
//  MenuViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import Combine
import Factory
import Foundation
import SwiftUI

@Observable @MainActor
final class MenuViewModel {
    var previousDayViewModel: DayViewModel
    var currentDayViewModel: DayViewModel
    var nextDayViewModel: DayViewModel

    private let calendarService = Container.shared.calendarService()
    private let eventService = Container.shared.eventService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        let previousDayTitle = String(localized: "previously").localizedCapitalized
        previousDayViewModel = DayViewModel(title: previousDayTitle, events: [])

        let todayTitle = String(localized: "today").localizedCapitalized
        currentDayViewModel = DayViewModel(title: todayTitle, events: [])

        let nextDayTitle = String(localized: "next").localizedCapitalized
        nextDayViewModel = DayViewModel(title: nextDayTitle, events: [])

        setupUpdateEventsBindings()
    }

    private func setupUpdateEventsBindings() {
        calendarService.allowedCalendarsPublisher.sink { [weak self] _ in
            self?.refresh()
        }
        .store(in: &cancellables)
    }

    func refresh() {
        let events = eventService.fetchEvents()

        // Previous events
        if let previousDay = Self.nextNonWeekendDay(since: Date(), isForward: false) {
            let previousDayEvents = events
                .filter { Calendar.current.isDate($0.startDate, inSameDayAs: previousDay) }
                .sorted { lhs, rhs in
                    lhs.startDate < rhs.startDate
                }
            let previousDayTitle = Self.title(for: previousDay)
            previousDayViewModel = DayViewModel(title: previousDayTitle, events: previousDayEvents)
        }

        // Today events
        let todayEvents = events
            .filter { Calendar.current.isDateInToday($0.startDate) }
            .sorted { lhs, rhs in
                lhs.startDate < rhs.startDate
            }

        let todayTitle = String(localized: "today").localizedCapitalized
        currentDayViewModel = DayViewModel(title: todayTitle, events: todayEvents)

        // Next events
        if let nextDay = Self.nextNonWeekendDay(since: Date(), isForward: true) {
            let nextDayEvents = events
                .filter { Calendar.current.isDate($0.startDate, inSameDayAs: nextDay) }
                .sorted { lhs, rhs in
                    lhs.startDate < rhs.startDate
                }
            let nextDayTitle = Self.title(for: nextDay)
            nextDayViewModel = DayViewModel(title: nextDayTitle, events: nextDayEvents)
        }
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
