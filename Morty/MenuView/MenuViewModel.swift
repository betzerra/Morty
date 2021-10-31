//
//  MenuViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 07/06/2021.
//

import AppKit
import Combine
import Foundation

private let yesterdayMenuTag = 1
private let yesterdayCopyTag = 10
private let todayMenuTag = 2
private let todayCopyTag = 20
private let tomorrowMenuTag = 3
private let tomorrowCopyTag = 30

private let menuItemViewWidth = 350.0

class MenuViewModel {
    weak var menu: NSMenu?

    private (set) var yesterdayViewModel: MenuDayViewModel!
    private (set) var todayViewModel: MenuDayViewModel!
    private (set) var tomorrowViewModel: MenuDayViewModel!

    var cancellables = [AnyCancellable]()

    init(menu: NSMenu?, eventsPublisher: AnyPublisher <[Event], Never>) {
        self.menu = menu

        guard
            let yesterdayMenuItem = menu?.item(withTag: yesterdayMenuTag),
            let yesterdayCopyMenuItem = menu?.item(withTag: yesterdayCopyTag),
            let todayMenuItem = menu?.item(withTag: todayMenuTag),
            let todayCopyMenuItem = menu?.item(withTag: todayCopyTag),
            let tomorrowMenuItem = menu?.item(withTag: tomorrowMenuTag),
            let tomorrowCopyMenuItem = menu?.item(withTag: tomorrowCopyTag) else {

                fatalError("Can't get menu items from IB")
            }

        yesterdayViewModel = viewModel(
            title: "yesterday",
            mainMenuItem: yesterdayMenuItem,
            copyMenuItem: yesterdayCopyMenuItem,
            publisher: eventsPublisher,
            eventFilter: { Calendar.current.isDateInYesterday($0.startDate) }
        )

        todayViewModel = viewModel(
            title: "today",
            mainMenuItem: todayMenuItem,
            copyMenuItem: todayCopyMenuItem,
            publisher: eventsPublisher,
            eventFilter: { Calendar.current.isDateInToday($0.startDate) }
        )

        tomorrowViewModel = viewModel(
            title: "tomorrow",
            mainMenuItem: tomorrowMenuItem,
            copyMenuItem: tomorrowCopyMenuItem,
            publisher: eventsPublisher,
            eventFilter: { Calendar.current.isDateInTomorrow($0.startDate) }
        )
    }

    private func viewModel(
        title: String,
        mainMenuItem: NSMenuItem,
        copyMenuItem: NSMenuItem,
        publisher: AnyPublisher<[Event], Never>,
        eventFilter: @escaping ((Event) -> Bool)
    ) -> MenuDayViewModel {

        let frame = NSRect(
            origin: .zero,
            size: CGSize(width: menuItemViewWidth, height: 0)
        )

        let view = MenuDayView(frame: frame)
        view.autoresizingMask = [.width, .height]
        mainMenuItem.view = view

        return MenuDayViewModel(
            title: title,
            view: view,
            copyMenuItem: copyMenuItem,
            publisher: publisher,
            eventFilter: eventFilter
        )
    }
}
