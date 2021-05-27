//
//  AppDelegate.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let eventsManager = EventsManager()
    
    var statusItem: NSStatusItem?
    @IBOutlet weak var menu: NSMenu?


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
}

private extension AppDelegate {
    func setupStatusItem() {
        // Set status item
        statusItem = NSStatusBar
            .system
            .statusItem(withLength: NSStatusItem.variableLength)
        
        statusItem?.button?.title = "Morty"
        
        // Set menu when icon is clicked
        if let menu = menu {
            statusItem?.menu = menu
        }
    }
    
    func standupTextToPasteboard() {
        let events = eventsManager.fetchEvents()
        let standup = EventsHelper.standupText(from: events)

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(standup, forType: .string)
    }
}
