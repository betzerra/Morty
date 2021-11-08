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
    private let fetchTimeInterval: TimeInterval = 60

    let eventsFetched: AnyPublisher <[Event], Never>
    private let _eventsFetched = CurrentValueSubject<[Event], Never>([])

    var store = EKEventStore()
    let settings: Settings

    var cancellables = [AnyCancellable]()

    init(settings: Settings) {
        self.settings = settings

        eventsFetched = _eventsFetched
            .prepend([])
            .eraseToAnyPublisher()

        // Fetch events every minute
        let timerPublisher: AnyPublisher<(), Never> = Timer
            .publish(every: fetchTimeInterval, on: .main, in: .default)
            .autoconnect()
            .map { _ in () }
            .eraseToAnyPublisher()

        // Fetch events every time the calendar changes
        let eventStoreChanged: AnyPublisher<(), Never> = NotificationCenter
            .default
            .publisher(for: .EKEventStoreChanged)
            .map { _ in () }
            .eraseToAnyPublisher()

        // Fetch events every time the selected calendars change
        let selectedCalendarsChanged: AnyPublisher<(), Never> = settings
            .$enabledCalendars
            .map { _ in () }
            .eraseToAnyPublisher()

        Publishers.Merge3(
            timerPublisher,
            eventStoreChanged,
            selectedCalendarsChanged
        )
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
            self?.updateDayEvents()
        }.store(in: &cancellables)
    }

    func requestAccess(completion: @escaping ((Bool, Error?) -> Void)) {
        store.requestAccess(to: .event, completion: completion)
    }

    static var isAuthorized: Bool {
        EKEventStore.authorizationStatus(for: .event) == .authorized
    }

    func fetchEvents() -> [EKEvent] {
        guard let yesterday = dateByAdding(days: -2),
              let tomorrow = dateByAdding(days: 2) else {

            return []
        }

        // Return events only from the calendars that the user previously selected
        let calendars = store
            .calendars(for: .event)
            .filter { settings.enabledCalendars.contains($0.calendarIdentifier) }

        guard calendars.count > 0 else {
            // Making a predicate with no items will be the same as
            // making a predicate with all the calendars
            return []
        }

        let predicate = store.predicateForEvents(
            withStart: yesterday,
            end: tomorrow,
            calendars: calendars
        )

        return store.events(matching: predicate)
    }

    func updateDayEvents() {
        let rawEvents = fetchEvents().map { Event(from: $0) }

        _eventsFetched.value = EventsManager.removeDuplicates(from: rawEvents)
    }

    // There's an app that makes mirror copies of meetings from other calendars except the
    // attendes. So I need to remove those.
    static func removeDuplicates(from events: [Event]) -> [Event] {
        // This array *might* contain duplicates
        let onePersonEvents = events.filter { $0.type == .onePerson }

        // This not
        let otherEvents = events.filter { $0.type != .onePerson }

        let filtered = onePersonEvents
            .filter { duplicated in
                !otherEvents.contains { $0.isDuplicate(of: duplicated) }
            }

        var retVal = Set<Event>(filtered)
        retVal.formUnion(otherEvents)
        return Array(retVal)
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
