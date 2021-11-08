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
    // An event that takes all day.
    // Usually a holiday, birthday, out of the office event, etc.
    case allDay

    // A regular meeting
    case meeting

    // A "meeting" that has no attendes.
    // Usually a doctor appointment, blocked time for coding, etc.
    case onePerson
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

        case .onePerson:
            return "👤"
        }
    }

    /// Tells if the event should be included
    /// in "time spent" summary
    var takesTime: Bool {
        return type != .allDay
    }

    func isDuplicate(of event: Event) -> Bool {
        return startDate == event.startDate &&
            endDate == event.endDate &&
            title == event.title
    }

    private var text: String {
        switch type {
        case .meeting, .onePerson:
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

        case .onePerson:
            return "person.fill"
        }
    }
}

// convenience init using EKEvent
extension Event {
    init(from event: EKEvent) {
        self.init(
            startDate: event.startDate,
            endDate: event.endDate,
            title: event.title,
            type: Event.type(from: event)
        )
    }

    static func type(from event: EKEvent) -> EventType {
        if event.isAllDay {
            return .allDay
        }

        if event.hasAttendees {
            return .meeting
        }

        return .onePerson
    }
}
