//
//  MortyTests.swift
//  MortyTests
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Foundation
import Testing

@testable import Morty

@MainActor
struct EventViewModelTests {

    @Test("Test title property", arguments: [
        (input: Event.mockMeetingEvent(), "2:05 PM - Eze <> Tonchis"),
        (input: Event.mockOnePersonEvent(), "3:30 PM - Focus Time"),
        (input: Event.mockAllDayEvent(), "Eze OOO"),
    ])
    func testTitle(value: (event: Event, expected: String)) {
        let viewModel = EventViewModel(event: value.event)
        #expect(viewModel.title == value.expected)
    }

    @Test("Test image name", arguments: [
        (input: Event.mockMeetingEvent(), "phone"),
        (input: Event.mockOnePersonEvent(), "person"),
        (input: Event.mockAllDayEvent(), "calendar"),
    ])
    func testImageName(value: (event: Event, expected: String)) {
        let viewModel = EventViewModel(event: value.event)
        #expect(viewModel.imageName == value.expected)
    }
}

private extension Event {
    static func mockMeetingEvent() -> Event {
        let startDate = Calendar.current.date(bySettingHour: 14, minute: 5, second: 0, of: Date())!
        let endDate = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
        return Event(
            id: "1",
            startDate: startDate,
            endDate: endDate,
            title: "Eze <> Tonchis",
            type: .meeting
        )
    }

    static func mockOnePersonEvent() -> Event {
        let startDate = Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: Date())!
        let endDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        return Event(
            id: "2",
            startDate: startDate,
            endDate: endDate,
            title: "Focus Time",
            type: .onePerson
        )
    }

    static func mockAllDayEvent() -> Event {
        let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        return Event(
            id: "3",
            startDate: startDate,
            endDate: endDate,
            title: "Eze OOO",
            type: .allDay
        )
    }
}
