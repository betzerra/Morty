//
//  EventServiceTests.swift
//  Morty
//
//  Created by Ezequiel Becerra on 04/02/2026.
//

import EventKit
import Factory
import FactoryTesting
import Foundation
import Testing

@testable import Morty

class EventServiceTests {
    let calendarService: CalendarServiceProtocolMock
    let defaultsService: DefaultsServiceProtocolMock
    let eventKitService: EKServiceProtocolMock

    init() {
        Scope.singleton.reset()

        // Mock DefaultsService
        let defaultsServiceMock = DefaultsServiceProtocolMock()
        Container.shared.defaultsService.register { @MainActor in
            defaultsServiceMock
        }
        defaultsService = defaultsServiceMock

        // Mock CalendarService
        let calendarServiceMock = CalendarServiceProtocolMock()
        Container.shared.calendarService.register { @MainActor in
            calendarServiceMock
        }
        calendarService = calendarServiceMock

        // Mock EKServiceProtocolMock
        let eventKitServiceMock = EKServiceProtocolMock()
        Container.shared.eventKitService.register { @MainActor in
            eventKitServiceMock
        }
        eventKitService = eventKitServiceMock
    }

    @Test @MainActor
    func fetchEvents() async throws {
        let isoFormatter = ISO8601DateFormatter()

        let mockedCalendarItem = EKCalendar(for: .event, eventStore: EKEventStore())
        mockedCalendarItem.title = "Foo"

        calendarService.allowedCalendars = [mockedCalendarItem.calendarIdentifier]

        eventKitService.calendarsHandler = { _ in
            // Mocking this because if calendars == 0, there will be no events
            return [mockedCalendarItem]
        }

        eventKitService.predicateForEventsHandler = { (_, _, _) in
            NSPredicate(value: true)
        }

        eventKitService.eventsHandler = { _ in
            return [
                Event(
                    id: "1",
                    startDate: isoFormatter.date(from: "2026-02-04T11:05:00Z")!,
                    endDate: isoFormatter.date(from: "2026-02-04T12:30:00Z")!,
                    title: "Stand up meeting",
                    type: .meeting
                ),
                Event(
                    id: "3",
                    startDate: isoFormatter.date(from: "2026-02-04T12:35:00Z")!,
                    endDate: isoFormatter.date(from: "2026-02-04T13:30:00Z")!,
                    title: "Eze <> Tonchis",
                    type: .meeting
                ),
                Event(
                    id: "2",
                    startDate: isoFormatter.date(from: "2026-02-04T11:05:00Z")!,
                    endDate: isoFormatter.date(from: "2026-02-04T12:30:00Z")!,
                    title: "Stand up meeting",
                    type: .onePerson
                ),
                Event(
                    id: "4",
                    startDate: isoFormatter.date(from: "2026-02-04T15:00:00Z")!,
                    endDate: isoFormatter.date(from: "2026-02-04T18:00:00Z")!,
                    title: "Focus Time",
                    type: .onePerson
                ),
                Event(
                    id: "5",
                    startDate: isoFormatter.date(from: "2026-02-04T00:00:00Z")!,
                    endDate: isoFormatter.date(from: "2026-02-04T23:59:59Z")!,
                    title: "Pay Day",
                    type: .allDay
                ),
                Event(
                    id: "6",
                    startDate: isoFormatter.date(from: "2026-02-04T00:00:00Z")!,
                    endDate: isoFormatter.date(from: "2026-02-04T23:59:59Z")!,
                    title: "Mom's Birthday",
                    type: .allDay
                )
            ]
        }

        let service = Container.shared.eventService()
        let events = service.fetchEvents()
        #expect(events.count == 5)

        let ids = events.map { $0.id }
        #expect(ids == ["6", "5", "1", "3", "4"])
    }
}
