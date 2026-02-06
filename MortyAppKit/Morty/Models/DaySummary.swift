//
//  DaySummary.swift
//  Morty
//
//  Created by Ezequiel Becerra on 06/11/2022.
//

import Foundation

enum DaySummary {
    case noEvents
    case someEvents(_ events: [Event], timeSpent: Double)

    var text: String? {
        switch self {
        case .noEvents:
            return "No meetings"
        case .someEvents(let events, let timeSpent):
            let filterOnePersonMeetings = AppDelegate
                .current
                .settings
                .filterOnePersonMeetings

            var text = events
                .filter({ event in
                    guard filterOnePersonMeetings else {
                        return true
                    }
                    return event.type != .onePerson
                })
                .map { $0.standupText }
                .joined(separator: "\n")

            if timeSpent > 0 {
                let timeSpentString = "\n\n🕓 \(TimeFormatter.string(fromSeconds: timeSpent)) spent in meetings"
                text.append(contentsOf: timeSpentString)
            }

            return text
        }
    }
}

extension Array where Element == Event {
    var summary: DaySummary {
        if self.count == 0 {
            return .noEvents
        }

        let timeSpent = self
            .filter { $0.takesTime }
            .compactMap { $0.endDate.timeIntervalSince($0.startDate) }
            .reduce(0, { $0 + $1 })

        return .someEvents(self, timeSpent: timeSpent)
    }
}
