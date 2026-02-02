//
//  EventsService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit

/// @mockable
protocol EventsServiceProtocol {
    /// Returns the authorization status calendar events
    var authorizationStatusForEvent: EKAuthorizationStatus { get }

    func requestAccessToEvents() async throws

    /// Searches for events that match the given predicate.
    func events(matching predicate: NSPredicate) -> [EKEvent]

    /// Returns calendars that support a given entity type (reminders, events)
    func calendars(for entityType: EKEntityType) -> [EKCalendar]

    /// Creates a simple query predicate to search for events within a certain date range.
    func predicateForEvents(withStart startDate: Date, end endDate: Date, calendars: [EKCalendar]?) -> NSPredicate
}

final class EventsService: EventsServiceProtocol {
    private let store = EKEventStore()

    var authorizationStatusForEvent: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    func requestAccessToEvents() async throws {
        try await store.requestFullAccessToEvents()
    }

    func events(matching predicate: NSPredicate) -> [EKEvent] {
        store.events(matching: predicate)
    }

    func calendars(for entityType: EKEntityType) -> [EKCalendar] {
        store.calendars(for: entityType)
    }

    func predicateForEvents(withStart startDate: Date, end endDate: Date, calendars: [EKCalendar]?) -> NSPredicate {
        store.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
    }
}
