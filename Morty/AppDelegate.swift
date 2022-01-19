//
//  AppDelegate.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

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

    lazy var preferencesWindowController: NSWindowController? = {
        let storyboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateController(withIdentifier: "preferences") as? NSWindowController
    }()
    
    @IBAction func preferencesTapped(_ sender: Any) {
        preferencesWindowController?.showWindow(self)
        preferencesWindowController?.window?.orderFrontRegardless()
    }

    // MARK: Private
    private func setupStatusItem() {
        // Set status item
        statusItem = NSStatusBar
            .system
            .statusItem(withLength: NSStatusItem.variableLength)

        statusItem?.button?.image = NSImage(named: "TrayIcon")

        // Set menu when icon is clicked
        if let menu = menu {
            statusItem?.menu = menu
        }
    }
}
