//
//  CalendarPickerViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import Combine
import Factory
import Foundation
import SwiftUI

@Observable @MainActor
final class CalendarPickerViewModel {
    private var eventKitService = Container.shared.eventKitService()
    private var calendarService = Container.shared.calendarService()

    var calendars: [CalendarItem] = []

    private var cancellables = Set<AnyCancellable>()

    var allowedCalendars: Set<String> {
        calendarService.allowedCalendars
    }

    init() {
        updateCalendars()

        eventKitService.authorizationStatusForEventChanged
            .sink { [weak self] _ in
                self?.updateCalendars()
            }
            .store(in: &cancellables)
    }

    func allowedCalendarsChange(_ value: Set<String>) {
        calendarService.allowedCalendars = value
    }

    private func updateCalendars() {
        calendars = calendarService.fetchCalendars()
    }
}
