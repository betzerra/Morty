//
//  MenuViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 07/06/2021.
//

import AppKit
import Combine
import Foundation

private let standupCopyTag = 100
private let yesterdayMenuTag = 1
private let yesterdayCopyTag = 10
private let todayMenuTag = 2
private let todayCopyTag = 20
private let tomorrowMenuTag = 3
private let tomorrowCopyTag = 30

private let menuItemViewWidth = 350.0

class MenuViewModel {
    weak var menu: NSMenu?
    let settings: Settings

    private (set) var yesterdayViewModel: MenuDayViewModel!
    private (set) var todayViewModel: MenuDayViewModel!
    private (set) var tomorrowViewModel: MenuDayViewModel!

    var cancellables = [AnyCancellable]()

    init(
        menu: NSMenu?,
        settings: Settings,
        eventsPublisher: AnyPublisher <[Event], Never>
    ) {
        self.menu = menu
        self.settings = settings

        guard
            let yesterdayMenuItem = menu?.item(withTag: yesterdayMenuTag),
            let yesterdayCopyMenuItem = menu?.item(withTag: yesterdayCopyTag),
            let todayMenuItem = menu?.item(withTag: todayMenuTag),
            let todayCopyMenuItem = menu?.item(withTag: todayCopyTag),
            let tomorrowMenuItem = menu?.item(withTag: tomorrowMenuTag),
            let tomorrowCopyMenuItem = menu?.item(withTag: tomorrowCopyTag),
            let standupCopyMenuItem = menu?.item(withTag: standupCopyTag) else {

                fatalError("Can't get menu items from IB")
            }

        yesterdayViewModel = viewModel(
            title: previousDay,
            mainMenuItem: yesterdayMenuItem,
            copyMenuItem: yesterdayCopyMenuItem,
            publisher: eventsPublisher,
            eventFilter: isFromPreviousDay(event:)
        )

        todayViewModel = viewModel(
            title: { return "Today" },
            mainMenuItem: todayMenuItem,
            copyMenuItem: todayCopyMenuItem,
            publisher: eventsPublisher,
            eventFilter: { Calendar.current.isDateInToday($0.startDate) }
        )

        tomorrowViewModel = viewModel(
            title: nextDay,
            mainMenuItem: tomorrowMenuItem,
            copyMenuItem: tomorrowCopyMenuItem,
            publisher: eventsPublisher,
            eventFilter: isFromNextDay(event:)
        )

        setupCopyStandup(standupCopyMenuItem)
    }

    private func setupCopyStandup(_ item: NSMenuItem) {
        item.isEnabled = true
        item.target = self
        item.action = #selector(copyStandupTapped)
        item.attributedTitle = "Copy standup.".attributed(leadingSymbol: "doc.on.clipboard.fill")
    }

    @objc func copyStandupTapped(_ sender: Any) {
        print("Copy standup tapped")
        let noMeetingsMessage = "No meetings"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        var pasteboardText = ""

        if let yesterdaySummary = yesterdayViewModel.summary,
           let yesterdayDate = settings.workdays ? Calendar.current.previousWeekday : Calendar.current.yesterday {
            let yesterdayHeader = "**\(dateFormatter.string(from: yesterdayDate)) (previously)**\n\n"
            pasteboardText += yesterdayHeader
            pasteboardText += yesterdaySummary.text ?? noMeetingsMessage
        }

        if let todaySummary = todayViewModel.summary {
            let todayHeader = "\n\n**\(dateFormatter.string(from: Date())) (today)**"
            let todayText = todaySummary.text ?? noMeetingsMessage

            pasteboardText += todayHeader
            pasteboardText += "\n\n\(todayText)"
        }

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(pasteboardText, forType: .string)
    }

    private func viewModel(
        title: @escaping (() -> String),
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

    private func isFromPreviousDay(event: Event) -> Bool {
        return isPreviousDay(date: event.startDate)
    }

    private func isFromNextDay(event: Event) -> Bool {
        return isNextDay(date: event.startDate)
    }

    /// Returns day before today.
    /// - NOTE: If 'workdays' is enabled and today is Monday, then it will return
    /// last Friday. Otherwise will return yesterday.
    private func isPreviousDay(date: Date) -> Bool {
        if settings.workdays {
            if let weekday = Calendar.current.previousWeekday {
                return Calendar.current.isDate(date, inSameDayAs: weekday)
            } else {
                // Defaults to yesterday
                return Calendar.current.isDateInYesterday(date)
            }
        } else {
            return Calendar.current.isDateInYesterday(date)
        }
    }

    /// Returns day after today.
    /// - NOTE: If 'workdays' is enabled and today is Friday, then it will return
    /// next Monday. Otherwise will return tomorrow.
    private func isNextDay(date: Date) -> Bool {
        if settings.workdays {
            if let weekday = Calendar.current.nextWeekday {
                return Calendar.current.isDate(date, inSameDayAs: weekday)
            } else {
                // Defaults to tomorrow
                return Calendar.current.isDateInTomorrow(date)
            }
        } else {
            return Calendar.current.isDateInTomorrow(date)
        }
    }

    private func previousDay() -> String {
        if settings.workdays {
            guard let date = Calendar.current.previousWeekday else {
                return "Previous"
            }
            return date.weekday
        } else {
            return "Yesterday"
        }
    }

    private func nextDay() -> String {
        if settings.workdays {
            guard let date = Calendar.current.nextWeekday else {
                return "Next"
            }
            return date.weekday
        } else {
            return "Tomorrow"
        }
    }
}
