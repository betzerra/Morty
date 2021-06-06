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

    init() {
        eventsFetched = _eventsFetched.eraseToAnyPublisher()
    }

    func requestAccess(completion: ((Bool, Error) -> Void)) {
        store.requestAccess(to: .event) { _, _ in }
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

    func updateEvents() {
        let events = fetchEvents()
            .map {
                Event.init(
                    date: $0.startDate,
                    title: $0.title,
                    type: .meeting
                )
            }

        _eventsFetched.value = events
    }
}

private func dateByAdding(days: Int) -> Date? {
    var components = DateComponents()
    components.day = days

    return Calendar.current.date(byAdding: components, to: Date())
}
