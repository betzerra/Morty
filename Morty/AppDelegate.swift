//
//  AppDelegate.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    let eventsManager = EventsManager()

    // Menu
    var statusItem: NSStatusItem?
    @IBOutlet weak var menu: NSMenu?

    // Calendar View
    @IBOutlet weak var calendarMenuItem: NSMenuItem?
    var calendarViewModel: CalendarViewModel?
    var calendarView: NSView?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusItem()

        // TODO: Handle request issue
        eventsManager.requestAccess { _, _ in }
    }

    func applicationWillTerminate(_ aNotification: Notification) {}

    // MARK: IBActions
    @IBAction func copyStandupToPasteboard(_ sender: Any) {

        standupTextToPasteboard()
    }

    // MARK: NSMenuDelegate
    func menuWillOpen(_ menu: NSMenu) {
        eventsManager.updateEvents()
    }

    // MARK: Private
    private func setupStatusItem() {
        // Set status item
        statusItem = NSStatusBar
            .system
            .statusItem(withLength: NSStatusItem.variableLength)

        statusItem?.button?.title = "Morty"

        // Set menu when icon is clicked
        if let menu = menu {
            statusItem?.menu = menu
            menu.delegate = self
        }

        if let calendarMenuItem = calendarMenuItem {
            let rect = NSRect(x: 0, y: 0, width: 250, height: 150)
            let view = CalendarView(frame: rect)
            calendarMenuItem.view = view

            calendarViewModel = CalendarViewModel(
                view: view,
                eventsPublisher: eventsManager.eventsFetched
            )
        }
    }

    private func standupTextToPasteboard() {
        let events = eventsManager
            .fetchEvents()
            .map {
                Event.init(
                    date: $0.startDate,
                    title: $0.title,
                    type: .meeting
                )
            }

        let standup = EventsHelper.standupText(from: events)

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(standup, forType: .string)
    }
}
