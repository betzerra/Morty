//
//  Event.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import Foundation
import AppKit
import EventKit

enum EventType: String, Codable {
    // An event that takes all day.
    // Usually a holiday, birthday, out of the office event, etc.
    case allDay

    // A regular meeting
    case meeting

    // A "meeting" that has no attendes.
    // Usually a doctor appointment, blocked time for coding, etc.
    case onePerson
}

struct Event: Codable, Hashable, Identifiable {
    let id: String
    let startDate: Date
    let endDate: Date
    let title: String
    let type: EventType

    var emoji: String {
        switch type {
        case .meeting:
            return "📞"

        case .allDay:
            return "📅"

        case .onePerson:
            return "👤"
        }
    }

    /// Tells if the event should be included
    /// in "time spent" summary
    var takesTime: Bool {
        return type == .meeting
    }

    func isDuplicate(of event: Event) -> Bool {
        return startDate == event.startDate &&
            endDate == event.endDate &&
            title == event.title
    }
}

// convenience init using EKEvent
extension Event {
    init(from event: EKEvent) {
        self.init(
            id: event.calendarItemIdentifier,
            startDate: event.startDate,
            endDate: event.endDate,
            title: event.title,
            type: Event.type(from: event)
        )
    }

    static func type(from event: EKEvent) -> EventType {
        if event.isAllDay {
            return .allDay
        }

        if event.hasAttendees {
            return .meeting
        }

        return .onePerson
    }
}
