//
//  MenuViewModelTests.swift
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

class MenuViewModelTests {
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
    func fetchEventsAndFullStandupText() {
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
                    startDate: Self.yesterdayDate(hour: 10, minute: 5),
                    endDate: Self.yesterdayDate(hour: 10, minute: 30),
                    title: "Stand up meeting",
                    type: .meeting
                ),
                Event(
                    id: "3",
                    startDate: Self.yesterdayDate(hour: 11, minute: 05),
                    endDate: Self.yesterdayDate(hour: 12, minute: 0),
                    title: "Eze <> Tonchis",
                    type: .meeting
                ),
                Event(
                    id: "2",
                    startDate: Self.yesterdayDate(hour: 10, minute: 5),
                    endDate: Self.yesterdayDate(hour: 10, minute: 30),
                    title: "Stand up meeting",
                    type: .onePerson
                ),
                Event(
                    id: "4",
                    startDate: Self.yesterdayDate(hour: 15, minute: 0),
                    endDate: Self.yesterdayDate(hour: 18, minute: 0),
                    title: "Focus Time",
                    type: .onePerson
                ),
                Event(
                    id: "5",
                    startDate: Self.yesterdayDate(hour: 0, minute: 0),
                    endDate: Self.yesterdayDate(hour: 23, minute: 59),
                    title: "Pay Day",
                    type: .allDay
                ),
                Event(
                    id: "6",
                    startDate: Self.yesterdayDate(hour: 0, minute: 0),
                    endDate: Self.yesterdayDate(hour: 23, minute: 59),
                    title: "Mom's Birthday",
                    type: .allDay
                ),
                Event(
                    id: "7",
                    startDate: Self.today(hour: 10, minute: 5),
                    endDate: Self.today(hour: 10, minute: 30),
                    title: "Stand up meeting",
                    type: .meeting
                ),
                Event(
                    id: "8",
                    startDate: Self.today(hour: 12, minute: 0),
                    endDate: Self.today(hour: 13, minute: 0),
                    title: "Lunch",
                    type: .onePerson
                ),
                Event(
                    id: "9",
                    startDate: Self.today(hour: 14, minute: 30),
                    endDate: Self.today(hour: 16, minute: 0),
                    title: "Focus Time",
                    type: .onePerson
                ),
                Event(
                    id: "10",
                    startDate: Self.tomorrowDate(hour: 12, minute: 0),
                    endDate: Self.tomorrowDate(hour: 13, minute: 0),
                    title: "Lunch",
                    type: .onePerson
                )
            ]
        }

        let service = Container.shared.eventService()
        let events = service.fetchEvents()
        #expect(events.count == 9)

        let viewModel = MenuViewModel()
        viewModel.update(events: events, reminders: Reminder.mockSet())

        // These asserts can fail during a weekend.
        #expect(viewModel.previousDayViewModel.events.count == 5)
        #expect(viewModel.currentDayViewModel.events.count == 3)
        #expect(viewModel.nextDayViewModel.events.count == 1)

        let expected = """
        1️⃣ How are you feeling? 🌡️

        2️⃣ What have you worked on since your last report? 📋
        Yesterday
        📅 Mom's Birthday
        📅 Pay Day
        📞 10:05 AM - Stand up meeting
        📞 11:05 AM - Eze <> Tonchis
        👤 3:00 PM - Focus Time

        🕓 1h 20m spent in meetings

        3️⃣ What will you do today? 📋
        📞 10:05 AM - Stand up meeting
        👤 12:00 PM - Lunch
        👤 2:30 PM - Focus Time

        🕓 25m spent in meetings

        📝 Fix important bug on Settings
        There's a bug on the settings screen that crashes the app

        📝 Unit Tests
        """

        #expect(viewModel.fullStandupText == expected)
    }

    private static func yesterdayDate(hour: Int, minute: Int) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
    }

    private static func tomorrowDate(hour: Int, minute: Int) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
    }

    private static func today(hour: Int, minute: Int) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }
}
