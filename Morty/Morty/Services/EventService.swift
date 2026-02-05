//
//  EventService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import EventKit
import Factory
import Foundation

/// @mockable
protocol EventServiceProtocol {
    func fetchEvents() -> [Event]
}

final class EventService: EventServiceProtocol {
    private let calendarService = Container.shared.calendarService()
    private let eventKitService = Container.shared.eventKitService()

    func fetchEvents() -> [Event] {
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
        let dayRange = 4

        guard let startDay = dateByAdding(days: -dayRange),
              let endDay = dateByAdding(days: dayRange) else {

            return []
        }

        let allowedCalendars = calendarService.allowedCalendars

        // Return events only from the calendars that the user previously selected
        let calendars = eventKitService
            .calendars(for: .event)
            .filter { allowedCalendars.contains($0.calendarIdentifier) }

        guard calendars.count > 0 else {
            // Making a predicate with no items will be the same as
            // making a predicate with all the calendars
            return []
        }

        let predicate = eventKitService.predicateForEvents(
            withStart: startDay,
            end: endDay,
            calendars: calendars
        )

        return eventKitService
            .events(matching: predicate)
            .removedDuplicates()
            .sortedByDefault()
    }

    private func dateByAdding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())
    }
}
