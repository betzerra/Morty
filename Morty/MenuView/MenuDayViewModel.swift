//
//  MenuDayViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 25/10/2021.
//

import AppKit
import Combine
import Foundation

enum DaySummary {
    case noEvents
    case someEvents(_ events: [Event], timeSpent: Double)
}

class MenuDayViewModel {
    let title: String
    var cancellables = [AnyCancellable]()
    var summary: DaySummary?

    init(
        title: String,
        view: MenuDayView,
        publisher: AnyPublisher<[Event], Never>,
        eventFilter: @escaping ((Event) -> Bool)
    ) {
        self.title = title

        publisher.sink { [weak self] events in
            let filteredEvents = events
                .filter(eventFilter)
                .sorted { lhs, rhs in
                    lhs.startDate < rhs.startDate
                }

            let summary = MenuDayViewModel.summary(from: filteredEvents)

            DispatchQueue.main.async { [weak self] in
                view.update(with: summary, title: title)

                self?.summary = summary
            }
        }
        .store(in: &cancellables)
    }

    static func summary(from events: [Event]) -> DaySummary {
        if events.count == 0 {
            return .noEvents
        }

        let timeSpent = events
            .compactMap { $0.endDate.timeIntervalSince($0.startDate) }
            .reduce(0, { $0 + $1 }) / 3600

        return .someEvents(events, timeSpent: timeSpent)
    }

    @objc func viewTapped(_ sender: Any) {
        print("\(title.capitalized) tapped")

        guard let summary = summary else {
            return
        }

        switch summary {
        case .noEvents:
            return

        case .someEvents(let events, let timeSpent):
            var text = events
                .map { $0.standupText }
                .joined(separator: "\n")

            let timeSpentString = String(format: "\n\n🕓 %.2f hours spent in meetings", timeSpent)
            text.append(contentsOf: timeSpentString)

            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString(text, forType: .string)
        }
    }
}
