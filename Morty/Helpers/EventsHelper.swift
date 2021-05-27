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
    let processed = process(events: events)
    var text = ""
    processed.forEach { key, events in
        text.append("\(key)\n")

        let textEvents = events.map { "- 📞 \($0)"}.joined(separator: "\n")
        text.append(textEvents)
        text.append("\n\n")
    }

    text.append("ℹ️ Calendar events expressed in my current time")

    return text
}

fileprivate func process(events: [EKEvent]) -> [String: [String]] {
    // Get different date components for all events (day, month, year)
    let dates = Set(events.map { anEvent -> DateComponents in
        return Calendar.current.dateComponents(
            [.day, .month, .year],
            from: anEvent.startDate
        )
    })

    // Group events by date
    var processedEvents: [String: [String]] = [:]

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

        let dayEvents = Set(events
            .filter { event in
                let eventComponent = Calendar.current.dateComponents(
                    [.day, .month, .year],
                    from: event.startDate
                )

                return component == eventComponent
            }
            .compactMap { "\(itemTimeFormatter.string(from: $0.startDate)) - \($0.title ?? "N/A")" })

        let key = keyDateFormatter.string(from: componentDate)
        processedEvents[key] = Array(dayEvents)
    }

    return processedEvents
}
