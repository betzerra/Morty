//
//  DayViewModelTests.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Foundation
import Testing

@testable import Morty

struct DayViewModelTests {
    @Test @MainActor
    func timeSpent() {
        let viewModel = DayViewModel(date: Date(), events: Event.mockDay())
        #expect(viewModel.timeSpent == 75 * 60.0)
        #expect(viewModel.timeSpentSummary == "1h 15m spent in meetings.")
    }

    @Test("Validate if title shows the relative date expected", arguments: [
        (date: Date(), expected: "Today"),
        (date: yesterday(), expected: "Yesterday"),
        (date: tomorrow(), expected: "Tomorrow")
    ]) @MainActor
    func title(value: (date: Date, expected: String)) {
        let viewModel = DayViewModel(date: value.date, events: [])
        #expect(viewModel.title == value.expected)
    }

    private static func yesterday() -> Date {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }

    private static func tomorrow() -> Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
}
