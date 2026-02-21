//
//  EKCalendarPickerViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import Combine
import EventKit
import Factory
import Foundation
import SwiftUI

@Observable @MainActor
final class EKCalendarPickerViewModel {
    private let type: EKEntityType
    private var eventKitService = Container.shared.eventKitService()
    private var calendarService = Container.shared.calendarService()

    var title: String = ""
    var subtitle: String = ""
    var calendars: [EKCalendarItem] = []

    private var cancellables = Set<AnyCancellable>()

    var allowedCalendars: Set<String> {
        calendarService.allowedCalendars
    }

    init(type: EKEntityType) {
        self.type = type

        switch type {
        case .event:
            title = String(localized: "settings.picker.event.title")
            subtitle = String(localized: "settings.picker.event.subtitle")
        case .reminder:
            title = String(localized: "settings.picker.reminder.title")
            subtitle = String(localized: "settings.picker.reminder.subtitle")
        @unknown default:
            fatalError("Unsupported type")
        }

        updateCalendars()

        eventKitService.authorizationStatusChanged
            // ignore Reminder authorization updates
            .filter { $0 == self.type }
            .sink { [weak self] _ in
                self?.updateCalendars()
            }
            .store(in: &cancellables)
    }

    func allowedCalendarsChange(_ value: Set<String>) {
        calendarService.allowedCalendars = value
    }

    private func updateCalendars() {
        calendars = calendarService.fetchCalendars(type: type)
    }
}
