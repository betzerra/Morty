//
//  AppDelegate.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    static var current: AppDelegate {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to reach AppDelegate")
        }

        return appDelegate
    }

    let settings = Settings.fromUserDefaults()
    var eventsManager: EventsManager!

    var menuViewModel: MenuViewModel?

    // Menu
    var statusItem: NSStatusItem?
    @IBOutlet weak var menu: NSMenu?

    // Today Menu Item
    @IBOutlet weak var todayMenuItem: NSMenuItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        eventsManager = EventsManager(settings: settings)

        setupStatusItem()

        menuViewModel = MenuViewModel(
            menu: menu,
            eventsPublisher: eventsManager.eventsFetched
        )

        eventsManager.updateDayEvents()
    }

    func applicationWillTerminate(_ aNotification: Notification) {}

    @IBAction func preferencesTapped(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)

        if let windowController =
            storyboard.instantiateController(withIdentifier: "preferences")
            as? NSWindowController {

            windowController.showWindow(self)
            windowController.window?.orderFrontRegardless()
        }
    }

    // MARK: NSMenuDelegate
    func menuWillOpen(_ menu: NSMenu) {
        eventsManager.updateDayEvents()
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
    }
}
