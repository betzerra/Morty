//
//  EventsService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit

/// EventKit wrapper service
/// @mockable
protocol EKServiceProtocol {
    /// Returns the authorization status calendar events
    var authorizationStatusForEvent: EKAuthorizationStatus { get }

    func requestAccessToEvents() async throws

    /// Searches for events that match the given predicate.
    func events(matching predicate: NSPredicate) -> [Event]

    /// Returns calendars that support a given entity type (reminders, events)
    func calendars(for entityType: EKEntityType) -> [EKCalendar]

    /// Creates a simple query predicate to search for events within a certain date range.
    func predicateForEvents(withStart startDate: Date, end endDate: Date, calendars: [EKCalendar]?) -> NSPredicate
}

final class EKService: EKServiceProtocol {
    private let store = EKEventStore()

    var authorizationStatusForEvent: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    func requestAccessToEvents() async throws {
        try await store.requestFullAccessToEvents()
    }

    func events(matching predicate: NSPredicate) -> [Event] {
        store.events(matching: predicate)
            .map { Event(from: $0) }
    }

    func calendars(for entityType: EKEntityType) -> [EKCalendar] {
        store.calendars(for: entityType)
    }

    func predicateForEvents(withStart startDate: Date, end endDate: Date, calendars: [EKCalendar]?) -> NSPredicate {
        store.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
    }
}
