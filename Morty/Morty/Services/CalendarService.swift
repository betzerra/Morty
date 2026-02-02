//
//  CalendarService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import EventKit
import Factory
import Foundation

/// @mockable
protocol CalendarServiceProtocol {
    func fetchCalendars() -> [CalendarItem]
    func fetchEvents() -> [EKEvent]

    var allowedCalendars: Set<String> { get set }
}

final class CalendarService: CalendarServiceProtocol {
    private let eventsService = Container.shared.eventsService()

    var allowedCalendars = Set<String>()

    func fetchCalendars() -> [CalendarItem] {
        eventsService
            .calendars(for: .event)
            .map {
                CalendarItem(
                    id: $0.calendarIdentifier,
                    title: $0.title,
                    source: $0.source.title,
                    color: $0.cgColor
                )
            }
            .sorted { lhs, rhs in
                return lhs.displayName < rhs.displayName
            }
    }

    func fetchEvents() -> [EKEvent] {
        // If 'workdays' is enabled, then we need to fetch more days in case
        // we need to cover the Friday / Monday gap.
        //
        // This could be improved by considering what day is today:
        //
        // For startDay:
        // 1. If today is Monday, then get last Friday.
        // 2. Otherwise, get yesterday.
        //
        // For endDay:
        // 1. If today is Friday, then get next Monday.
        // 2. Otherwise, get tomorrow
        // let dayRange = settings.workdays ? 4 : 2
        let dayRange = 2

        guard let startDay = dateByAdding(days: -dayRange),
              let endDay = dateByAdding(days: dayRange) else {

            return []
        }

        // Return events only from the calendars that the user previously selected
        let calendars = eventsService
            .calendars(for: .event)
            .filter { allowedCalendars.contains($0.calendarIdentifier) }

        guard calendars.count > 0 else {
            // Making a predicate with no items will be the same as
            // making a predicate with all the calendars
            return []
        }

        let predicate = eventsService.predicateForEvents(
            withStart: startDay,
            end: endDay,
            calendars: calendars
        )

        return eventsService.events(matching: predicate)
    }

    private func dateByAdding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())
    }
}
