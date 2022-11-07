//
//  MenuDayViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 25/10/2021.
//

import AppKit
import Combine
import Foundation

class MenuDayViewModel {
    let title: (() -> String)
    var cancellables = [AnyCancellable]()
    var summary: DaySummary?

    init(
        title: @escaping (() -> String),
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

                return filteredEvents.summary
            })
            .receive(on: RunLoop.main)
            .sink { [weak self] summary in
                view.update(with: summary, title: title())

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
        item.attributedTitle = "Copy \(title())'s items.".attributed(leadingSymbol: "doc.on.clipboard.fill")
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
        print("\(title().capitalized) tapped")

        guard let text = summary?.text else {
            return
        }

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
    }
}
