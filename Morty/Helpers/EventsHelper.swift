//
//  EventsHelper.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Foundation
import EventKit

class EventsHelper {
    static func standupText(from events: [Event]) -> String {
        let days = days(from: events)
        return textFrom(days: days)
    }

    static func days(from events: [Event]) -> [Day] {
        // Get different date components for all events (day, month, year)
        let dates = Set(events.map { anEvent -> DateComponents in
            return Calendar.current.dateComponents(
                [.day, .month, .year],
                from: anEvent.startDate
            )
        })

        // Group events by day
        var days: [Day] = []

        dates.forEach { component in
            guard let componentDate = Calendar.current.date(from: component) else {
                return
            }

            let dayEvents = Set(
                events
                    .filter { event in
                        let eventComponent = Calendar.current.dateComponents(
                            [.day, .month, .year],
                            from: event.startDate
                        )

                        return component == eventComponent
                    }
            )

            let sortedDayEvents = Array(dayEvents)
                .sorted { lEvent, rEvent in
                    return lEvent.startDate < rEvent.startDate
                }

            let day = Day(events: sortedDayEvents, date: componentDate)
            days.append(day)
        }

        let sortedDays = Array(days)
            .sorted { lDay, rDay in
                return lDay.date < rDay.date
            }
        return sortedDays
    }
}

private func textFrom(days: [Day]) -> String {
    var text = ""
    days.forEach { day in
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short

        text.append("\(formatter.string(from: day.date))\n")

        let textEvents = day.events.map { $0.standupText }.joined(separator: "\n")
        text.append(textEvents)
        text.append("\n\n")
    }

    return text
}
