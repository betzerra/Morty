//
//  DayEventHandler.swift
//  Morty
//
//  Created by Ezequiel Becerra on 09/10/2021.
//

import Foundation
import AppKit

class DayEventHandler {
    var events: [Event]?

    let titleTag: Int
    let itemsTag: Int

    let dayDescription: String // Today / Yesterday

    var menuItems: [NSMenuItem] {

        guard let events = events, events.count > 0 else {
            return [noEventsMenuItem()]
        }

        var items: [NSMenuItem] = events.map { event in
            let item = NSMenuItem(
                title: event.standupText,
                action: nil,
                keyEquivalent: ""
            )

            item.tag = itemsTag
            return item
        }

        items.append(copyItemsToClipboardItem())
        return items
    }

    init(titleTag: Int, itemsTag: Int, dayDescription: String) {
        self.titleTag = titleTag
        self.itemsTag = itemsTag
        self.dayDescription = dayDescription
    }

    @objc private func copyToClipboard() {
        guard let events = events else {
            return
        }

        let standup = EventsHelper.standupText(from: events)

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(standup, forType: .string)
    }

    private func noEventsMenuItem() -> NSMenuItem {
        let item = NSMenuItem(
            title: "No events! 🎉",
            action: nil,
            keyEquivalent: ""
        )
        item.tag = itemsTag
        return item
    }

    private func copyItemsToClipboardItem() -> NSMenuItem {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: nil)

        let title = NSMutableAttributedString()
        title.append(NSAttributedString(attachment: imageAttachment))
        title.append(NSAttributedString(string: " Copy \(dayDescription)'s items."))

        let item = NSMenuItem()
        item.attributedTitle = title
        item.target = self
        item.action = #selector(copyToClipboard)
        item.tag = itemsTag
        item.isEnabled = true
        return item
    }
}
