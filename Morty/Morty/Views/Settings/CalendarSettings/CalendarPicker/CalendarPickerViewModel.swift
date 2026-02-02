//
//  CalendarPickerViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import Factory
import Foundation
import SwiftUI

@Observable @MainActor
final class CalendarPickerViewModel {
    private var calendarService = Container.shared.calendarService()

    var calendars: [CalendarItem] = []

    init() {
        calendars = calendarService
            .fetchCalendars()
    }

    func allowedCalendarsChange(_ value: Set<String>) {
        calendarService.allowedCalendars = value
    }
}
