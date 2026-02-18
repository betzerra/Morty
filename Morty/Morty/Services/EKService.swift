//
//  EventsService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Combine
import EventKit

/// EventKit wrapper service
/// @mockable
protocol EKServiceProtocol {
    /// Authorization status for an specific type (calendar/reminder) has changed
    var authorizationStatusChanged: AnyPublisher<EKEntityType, Never> { get }

    /// Request access to calendar/reminder events
    func requestAccess(to type: EKEntityType) async throws

    /// Returns the authorization status calendar/reminder events
    func authorizationStatus(for type: EKEntityType) -> EKAuthorizationStatus

    /// Searches for events that match the given predicate.
    func events(matching predicate: NSPredicate) -> [Event]

    /// Returns calendars that support a given entity type (reminders, events)
    func calendars(for entityType: EKEntityType) -> [EKCalendar]

    /// Creates a simple query predicate to search for events within a certain date range.
    func predicateForEvents(withStart startDate: Date, end endDate: Date, calendars: [EKCalendar]?) -> NSPredicate
}

final class EKService: EKServiceProtocol {
    private let store = EKEventStore()
    private let _authorizationStatusChanged = PassthroughSubject<EKEntityType, Never>()

    lazy var authorizationStatusChanged: AnyPublisher<EKEntityType, Never> = { _authorizationStatusChanged.eraseToAnyPublisher()
    }()

    func authorizationStatus(for type: EKEntityType) -> EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: type)
    }

    func requestAccess(to type: EKEntityType) async throws {
        switch type {
        case .event:
            if try await store.requestFullAccessToEvents() {
                _authorizationStatusChanged.send(.event)
            }
        case .reminder:
            if try await store.requestFullAccessToReminders() {
                _authorizationStatusChanged.send(.reminder)
            }
        @unknown default:
            fatalError("Unsupported type")
        }
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
