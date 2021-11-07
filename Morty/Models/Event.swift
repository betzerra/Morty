//
//  Event.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import Foundation
import AppKit
import EventKit

enum EventType: String, Codable {
    case meeting
    case allDay
}

struct Event: Codable, Hashable {
    let startDate: Date
    let endDate: Date
    let title: String
    let type: EventType

    var standupText: String {
        "\(emoji) \(text)"
    }

    var emoji: String {
        switch type {
        case .meeting:
            return "📞"

        case .allDay:
            return "📅"
        }
    }

    private var text: String {
        switch type {
        case .meeting:
            return "\(startDate.time) - \(title)"

        case .allDay:
            return title
        }

    }
}

extension Event {
    var attributedText: NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil)

        let attributedImage = NSMutableAttributedString(attachment: imageAttachment)
        attributedImage.addAttribute(
            .foregroundColor,
            value: NSColor.secondaryLabelColor,
            range: NSRange(location: 0, length: attributedImage.length)
        )

        let attributed = NSMutableAttributedString()
        attributed.append(attributedImage)
        attributed.append(NSAttributedString(string: " \(text)"))

        return attributed
    }

    var symbolName: String {
        switch type {
        case .meeting:
            return "phone"

        case .allDay:
            return "calendar"
        }
    }
}

// convenience init using EKEvent
extension Event {
    init(from event: EKEvent) {
        let eventType: EventType = event.isAllDay ? .allDay : .meeting

        self.init(
            startDate: event.startDate,
            endDate: event.endDate,
            title: event.title,
            type: eventType
        )
    }
}
