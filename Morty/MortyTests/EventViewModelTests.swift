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
    func title(value: (event: Event, expected: String)) {
        let viewModel = EventViewModel(event: value.event)
        #expect(viewModel.title == value.expected)
    }

    @Test("Test image name", arguments: [
        (input: Event.mockMeetingEvent(), "phone"),
        (input: Event.mockOnePersonEvent(), "person"),
        (input: Event.mockAllDayEvent(), "calendar"),
    ])
    func imageName(value: (event: Event, expected: String)) {
        let viewModel = EventViewModel(event: value.event)
        #expect(viewModel.imageName == value.expected)
    }
}
