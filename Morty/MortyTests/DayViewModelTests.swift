//
//  DayViewModelTests.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Factory
import Foundation
import Testing

@testable import Morty

final class DayViewModelTests {
    let defaultsService: DefaultsServiceProtocolMock

    init() {
        Scope.singleton.reset()

        // Mock DefaultsService
        let defaultsServiceMock = DefaultsServiceProtocolMock()
        Container.shared.defaultsService.register { @MainActor in
            defaultsServiceMock
        }
        defaultsService = defaultsServiceMock
    }

    @Test @MainActor
    func timeSpent() {
        let viewModel = DayViewModel(title: "Today", events: Event.mockDay())
        #expect(viewModel.timeSpent == 75 * 60.0)
        #expect(viewModel.timeSpentSummary == "1h 15m spent in meetings.")
    }

    @Test @MainActor
    func standupTextWithoutOnePersonEvents() {
        defaultsService.filterOnePersonMeetings = true
        let viewModel = DayViewModel(title: "Today", events: Event.mockDay())

        let expected = """
        📅 Eze OOO
        📞 2:05 PM - Eze <> Tonchis
        📞 3:05 PM - Standup Meeting

        🕓 1h 15m spent in meetings
        """

        #expect(viewModel.standupText == expected)
    }

    @Test @MainActor
    func standupTextWithOnePersonEvents() {
        defaultsService.filterOnePersonMeetings = false
        let viewModel = DayViewModel(title: "Today", events: Event.mockDay())

        let expected = """
        📅 Eze OOO
        📞 2:05 PM - Eze <> Tonchis
        📞 3:05 PM - Standup Meeting
        👤 3:30 PM - Focus Time

        🕓 1h 15m spent in meetings
        """

        #expect(viewModel.standupText == expected)
    }
}
