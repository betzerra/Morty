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
private let yesterdayItemsTag = 90
private let todayTitleTag = 10
private let todayItemsTag = 100
private let tomorrowTitleTag = 11
private let tomorrowItemsTag = 110

class MenuViewModel {
    weak var menu: NSMenu?

    let todayHandler = DayEventHandler(
        titleTag: todayTitleTag,
        itemsTag: todayItemsTag,
        dayDescription: "today"
    )

    let yesterdayHandler = DayEventHandler(
        titleTag: yesterdayTitleTag,
        itemsTag: yesterdayItemsTag,
        dayDescription: "yesterday"
    )

    let tomorrowHandler = DayEventHandler(
        titleTag: tomorrowTitleTag,
        itemsTag: tomorrowItemsTag,
        dayDescription: "tomorrow"
    )

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

                self.updateDayHandler(
                    self.todayHandler,
                    with: events.filter { Calendar.current.isDateInToday($0.date) }
                )

                self.updateDayHandler(
                    self.yesterdayHandler,
                    with: events.filter { Calendar.current.isDateInYesterday($0.date) }
                )

                self.updateDayHandler(
                    self.tomorrowHandler,
                    with: events.filter { Calendar.current.isDateInTomorrow($0.date) }
                )
            }
            .store(in: &cancellables)
    }

    private func updateDayHandler(_ handler: DayEventHandler, with events: [Event]) {
        // Remove old elements from menu
        removeItems(with: handler.itemsTag)

        // Update handler's events
        handler.events = events

        // Add new items to Menu
        addItems(from: handler)
    }

    private func removeItems(with tag: Int) {
        guard let menu = menu else {
            return
        }

        while let item = menu.item(withTag: tag) {
            menu.removeItem(item)
        }
    }

    private func addItems(from handler: DayEventHandler) {
        guard let tagIndex = menu?.indexOfItem(withTag: handler.titleTag) else {
            return
        }

        handler.menuItems.enumerated().forEach { (index, item) in
            menu?.insertItem(item, at: tagIndex + index + 1)
        }
    }
}
