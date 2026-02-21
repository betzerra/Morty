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

extension Array where Element == Event {
    func removedDuplicates() -> [Event] {
        Self.removeDuplicates(from: self)
    }

    func sortedByDefault() -> [Event] {
        self.sorted { lhs, rhs in
            if lhs.type == rhs.type {
                if lhs.startDate == rhs.startDate {
                    return lhs.title < rhs.title
                }
                return lhs.startDate < rhs.startDate
            }

            if lhs.type == .allDay {
                return true
            }

            return lhs.startDate < rhs.startDate
        }
    }

    private static func removeDuplicates(from events: [Event]) -> [Event] {
        var tmp = [Event]()

        events.forEach { event in
            let foundIndex = tmp.firstIndex(where: { $0.isDuplicate(of: event) })
            if let index = foundIndex {
                let found = tmp[index]

                switch (found.type, event.type) {
                case (.onePerson, .meeting):
                    // remove existing event and add the new one
                    tmp.remove(at: index)
                    tmp.append(event)

                case (.meeting, .onePerson):
                    // keep the one that currently exists,
                    // meeting copy should prevail
                    break

                case (let lhs, let rhs) where lhs == rhs:
                    // keep the one that currently exists,
                    // they are the same
                    break

                default:
                    tmp.append(event)
                }
            } else {
                tmp.append(event)
            }
        }
        return tmp
    }
}
