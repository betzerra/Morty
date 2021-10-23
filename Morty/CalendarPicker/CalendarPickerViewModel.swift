//
//  CalendarPickerViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 23/10/2021.
//

import Foundation
import EventKit

extension EKCalendar {
    var calendarTitle: String {
        if source.title.isEmpty {
            return title
        } else {
            return "\(source.title) - \(title)"
        }
    }
}

class CalendarPickerViewModel {
    let eventsManager = EventsManager()

    lazy var calendars: [EKCalendar] = {
        eventsManager
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

                return lhs.calendarTitle < rhs.calendarTitle
            }
    }()
}
