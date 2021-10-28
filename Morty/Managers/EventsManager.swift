//
//  EventsManager.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Combine
import Foundation
import EventKit

class EventsManager {
    let eventsFetched: AnyPublisher <[Event], Never>
    private let _eventsFetched = CurrentValueSubject<[Event], Never>([])

    var store = EKEventStore()
    let settings: Settings

    init(settings: Settings) {
        self.settings = settings
        eventsFetched = _eventsFetched.eraseToAnyPublisher()
    }

    func requestAccess(completion: ((Bool, Error) -> Void)) {
        store.requestAccess(to: .event) { _, _ in }
    }

    static var isAuthorized: Bool {
        EKEventStore.authorizationStatus(for: .event) == .authorized
    }

    func fetchEvents() -> [EKEvent] {
        guard let yesterday = dateByAdding(days: -1),
              let tomorrow = dateByAdding(days: 1) else {

            return []
        }

        // Return events only from the calendars that the user previously selected
        let calendars = store
            .calendars(for: .event)
            .filter { settings.enabledCalendars.contains($0.calendarIdentifier) }

        let predicate = store.predicateForEvents(
            withStart: yesterday,
            end: tomorrow,
            calendars: calendars
        )

        return store.events(matching: predicate)
    }

    func updateDayEvents() {
        let rawEvents = fetchEvents()
            .map {
                Event.init(
                    startDate: $0.startDate,
                    endDate: $0.endDate,
                    title: $0.title,
                    type: .meeting
                )
            }

        // Remove duplicates
        let events = Array(Set(rawEvents))
        _eventsFetched.value = events
    }

    func isCalendarEnabled(identifier: String) -> Bool {
        settings.enabledCalendars.contains(identifier)
    }

    func enableCalendar(_ identifier: String, enabled: Bool) {
        if enabled {
            settings.enabledCalendars.insert(identifier)
        } else {
            settings.enabledCalendars.remove(identifier)
        }
    }
}

private func dateByAdding(days: Int) -> Date? {
    var components = DateComponents()
    components.day = days

    return Calendar.current.date(byAdding: components, to: Date())
}
