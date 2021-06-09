//
//  MenuViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 07/06/2021.
//

import AppKit
import Combine
import Foundation

private let yesterdayTitleTag = 9
private let yesterdayItemsTag = 99
private let todayTitleTag = 10
private let todayItemsTag = 100

class MenuViewModel {
    weak var menu: NSMenu?
    var cancellables = [AnyCancellable]()

    init(menu: NSMenu?, eventsPublisher: AnyPublisher <[Day], Never>) {
        self.menu = menu

        eventsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] days in
                guard let self = self else {
                    return
                }

                let events = days.flatMap { $0.events }

                self.updateYesterday(from: events)
                self.updateToday(from: events)
            }
            .store(in: &cancellables)
    }

    private func updateYesterday(from events: [Event]) {
        removeItems(with: yesterdayItemsTag)

        let yesterdayEvents = events
            .filter { Calendar.current.isDateInYesterday($0.date) }

        addItems(
            events: yesterdayEvents,
            after: yesterdayTitleTag,
            tag: yesterdayItemsTag
        )
    }

    private func updateToday(from events: [Event]) {
        self.removeItems(with: todayItemsTag)
        let todayEvents = events
            .filter { Calendar.current.isDateInToday($0.date) }

        self.addItems(
            events: todayEvents,
            after: todayTitleTag,
            tag: todayItemsTag
        )
    }

    private func removeItems(with tag: Int) {
        guard let menu = menu else {
            return
        }

        while let item = menu.item(withTag: tag) {
            menu.removeItem(item)
        }
    }

    private func addItems(
        events: [Event],
        after referenceTag: Int,
        tag: Int
    ) {
        guard let tagIndex = menu?.indexOfItem(withTag: referenceTag) else {
            return
        }

        guard events.count > 0 else {
            // If there's no items to add.
            // Add one saying there're no items!
            let item = NSMenuItem(
                title: "No events! 🎉",
                action: nil,
                keyEquivalent: ""
            )
            item.tag = tag

            menu?.insertItem(item, at: tagIndex + 1)
            return
        }

        events.enumerated().forEach { (index, element) in
            let item = NSMenuItem(
                title: element.standupText,
                action: nil,
                keyEquivalent: ""
            )

            item.tag = tag

            menu?.insertItem(item, at: tagIndex + index + 1)
        }
    }
}
