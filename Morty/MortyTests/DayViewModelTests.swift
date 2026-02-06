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
        let viewModel = DayViewModel(title: "Today", events: Event.mockDay())
        #expect(viewModel.timeSpent == 75 * 60.0)
        #expect(viewModel.timeSpentSummary == "1h 15m spent in meetings.")
    }
}
