//
//  EventsHelper.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Foundation
import EventKit

class EventsHelper {
    static func standupText(from events:[EKEvent]) -> String {
        return textFrom(events: events)
    }
}

fileprivate func textFrom(events: [EKEvent]) -> String {
    let mortyEvents = events
        .map { Event(date: $0.startDate, title: $0.title, type: .meeting) }
    
    let processed = process(events: mortyEvents)
    var text = ""
    processed.forEach { key, events in
        text.append("\(key)\n")

        let textEvents = events.map { $0.standupText }.joined(separator: "\n")
        text.append(textEvents)
    }

    return text
}

fileprivate func process(events: [Event]) -> [String: [Event]] {
    // Get different date components for all events (day, month, year)
    let dates = Set(events.map { anEvent -> DateComponents in
        return Calendar.current.dateComponents(
            [.day, .month, .year],
            from: anEvent.date
        )
    })

    // Group events by date
    var processedEvents: [String: [Event]] = [:]

    dates.forEach { component in
        guard let componentDate = Calendar.current.date(from: component) else {
            return
        }

        let keyDateFormatter = DateFormatter()
        keyDateFormatter.dateStyle = .short
        keyDateFormatter.timeStyle = .none

        let itemTimeFormatter = DateFormatter()
        itemTimeFormatter.dateStyle = .none
        itemTimeFormatter.timeStyle = .short
        itemTimeFormatter.timeZone = .current

        let dayEvents = Set(
            events
                .filter { event in
                    let eventComponent = Calendar.current.dateComponents(
                        [.day, .month, .year],
                        from: event.date
                    )
                    
                    return component == eventComponent
                }
        )

        let key = keyDateFormatter.string(from: componentDate)
        processedEvents[key] = Array(dayEvents).sorted(by: { lEvent, rEvent in
            return lEvent.date < rEvent.date
        })
    }

    return processedEvents
}
