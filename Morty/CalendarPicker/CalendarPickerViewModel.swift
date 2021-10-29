//
//  CalendarPickerViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 23/10/2021.
//

import AppKit
import EventKit
import Foundation

class CalendarPickerViewModel {
    var calendars: [EKCalendar] {
        AppDelegate.current.eventsManager
            .store.calendars(for: .event)
            .sorted { lhs, rhs in
                if lhs.source.title.isEmpty && rhs.source.title.isEmpty {
                    return lhs.title < rhs.title
                }

                if lhs.source.title.isEmpty {
                    return true
                }

                if rhs.source.title.isEmpty {
                    return false
                }

                return lhs.displayTitle < rhs.displayTitle
            }
    }

    func enableCalendar(_ identifier: String, _ enable: Bool) {
        AppDelegate
            .current
            .eventsManager
            .enableCalendar(identifier, enabled: enable)
    }

    func checkBoxState(for calendar: EKCalendar) -> NSControl.StateValue {
        AppDelegate
            .current
            .eventsManager
            .isCalendarEnabled(identifier: calendar.calendarIdentifier) ? .on : .off
    }
}
