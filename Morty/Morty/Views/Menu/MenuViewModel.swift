//
//  MenuViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import Combine
import Factory
import Foundation
import SwiftUI

@Observable @MainActor
final class MenuViewModel {
    var currentDayViewModel = DayViewModel(date: Date(), events: [])

    private let calendarService = Container.shared.calendarService()
    private let eventService = Container.shared.eventService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupUpdateEventsBindings()
    }

    private func setupUpdateEventsBindings() {
        calendarService.allowedCalendarsPublisher.sink { [weak self] _ in
            self?.refresh()
        }
        .store(in: &cancellables)
    }

    func refresh() {
        let events = eventService.fetchEvents()
            .map { Event(from: $0) }

        currentDayViewModel = DayViewModel(date: Date(), events: events)
    }
}
