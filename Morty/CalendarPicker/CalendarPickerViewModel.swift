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
    lazy var calendars: [EKCalendar] = {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            assert(false, "Unable to reach AppDelegate")
        }

        return appDelegate.eventsManager
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
    }()

    func enableCalendar(_ identifier: String, _ enable: Bool) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            assert(false, "Unable to reach AppDelegate")
        }

        appDelegate
            .eventsManager
            .enableCalender(identifier, enabled: enable)
    }

    func checkBoxState(for calendar: EKCalendar) -> NSControl.StateValue {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            assert(false, "Unable to reach AppDelegate")
        }

        return appDelegate
            .eventsManager
            .isCalendarEnabled(identifier: calendar.calendarIdentifier) ? .on : .off
    }
}
