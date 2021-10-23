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
    let dayEventsFetched: AnyPublisher <[Day], Never>
    private let _dayEventsFetched = CurrentValueSubject<[Day], Never>([])

    var store = EKEventStore()
    let settings: Settings

    init(settings: Settings) {
        self.settings = settings
        dayEventsFetched = _dayEventsFetched.eraseToAnyPublisher()
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

        let predicate = store.predicateForEvents(
            withStart: yesterday,
            end: tomorrow,
            calendars: nil
        )

        return store.events(matching: predicate)
    }

    func updateDayEvents() {
        let events = fetchEvents()
            .map {
                Event.init(
                    date: $0.startDate,
                    title: $0.title,
                    type: .meeting
                )
            }

        _dayEventsFetched.value = EventsHelper.days(from: events)
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
