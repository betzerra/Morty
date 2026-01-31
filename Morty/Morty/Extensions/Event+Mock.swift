//
//  Event+Mock.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Foundation

extension Event {
    static func mock(title: String, type: EventType) -> Self {
        Event(
            id: UUID().uuidString,
            startDate: Date(timeIntervalSinceNow: -60*60*24),
            endDate: Date(timeIntervalSinceNow: -60*60*23),
            title: title,
            type: type
        )
    }

    // 75m timeSpent
    static func mockDay() -> [Event] {
        [
            mockMeetingEvent(), // 55m timeSpent
            Event(
                id: "4",
                startDate: dateToday(hour: 15, minute: 5),
                endDate: dateToday(hour: 15, minute: 25),
                title: "Standup Meeting", type: .meeting
            ),
            mockOnePersonEvent(),
            mockAllDayEvent()
        ]
    }

    static func mockMeetingEvent() -> Event {
        Event(
            id: "1",
            startDate: Self.dateToday(hour: 14, minute: 5),
            endDate: Self.dateToday(hour: 15, minute: 0),
            title: "Eze <> Tonchis",
            type: .meeting
        )
    }

    static func mockOnePersonEvent() -> Event {
        Event(
            id: "2",
            startDate: Self.dateToday(hour: 15, minute: 30),
            endDate: Self.dateToday(hour: 18, minute: 0),
            title: "Focus Time",
            type: .onePerson
        )
    }

    static func mockAllDayEvent() -> Event {
        Event(
            id: "3",
            startDate: Self.dateToday(hour: 0, minute: 0),
            endDate: Self.dateToday(hour: 23, minute: 59),
            title: "Eze OOO",
            type: .allDay
        )
    }

    private static func dateToday(hour: Int, minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }
}
