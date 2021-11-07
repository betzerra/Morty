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
        copyMenuItem: NSMenuItem,
        publisher: AnyPublisher<[Event], Never>,
        eventFilter: @escaping ((Event) -> Bool)
    ) {
        self.title = title
        setupCopyMenuItem(copyMenuItem)

        publisher
            .map({ events -> DaySummary in
                let filteredEvents = events
                    .filter(eventFilter)
                    .sorted { lhs, rhs in
                        lhs.startDate < rhs.startDate
                    }

                return MenuDayViewModel.summary(from: filteredEvents)
            })
            .receive(on: RunLoop.main)
            .sink { [weak self] summary in
                view.update(with: summary, title: title)

                MenuDayViewModel.updateCopyMenuItem(
                    copyMenuItem,
                    with: summary
                )

                self?.summary = summary
            }
            .store(in: &cancellables)
    }

    func setupCopyMenuItem(_ item: NSMenuItem) {
        item.isEnabled = true
        item.target = self
        item.action = #selector(viewTapped)
        item.attributedTitle = "Copy \(title)'s items.".attributed(leadingSymbol: "doc.on.clipboard.fill")
    }

    static func summary(from events: [Event]) -> DaySummary {
        if events.count == 0 {
            return .noEvents
        }

        let timeSpent = events
            .compactMap { $0.endDate.timeIntervalSince($0.startDate) }
            .reduce(0, { $0 + $1 })

        return .someEvents(events, timeSpent: timeSpent)
    }

    static func updateCopyMenuItem(
        _ item: NSMenuItem,
        with summary: DaySummary
    ) {
        switch summary {
        case .noEvents:
            item.isHidden = true
        case .someEvents(_, _):
            item.isHidden = false
        }
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

    static func timeSpentFormatted(from timeSpent: Double) -> String {
        var minutes = timeSpent / 60
        let hours = floor(minutes / 60)

        if hours >= 1.0 {
            minutes -= (hours * 60)
            if minutes >= 1.0 {
                return String(format: "%.0fh %.0fm", hours, minutes)
            } else {
                return String(format: "%.0fh", hours, minutes)
            }
        } else {
            return String(format: "%.0fm", minutes)
        }
    }
}
