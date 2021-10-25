//
//  Event.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import Foundation
import AppKit

enum EventType: String, Codable {
    case meeting
}

struct Event: Codable, Hashable {
    let startDate: Date
    let endDate: Date
    let title: String
    let type: EventType

    var standupText: String {
        "📞 \(text)"
    }

    private var text: String {
        "\(startDate.time) - \(title)"
    }
}

extension Event {
    var attributedText: NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = NSImage(systemSymbolName: "phone", accessibilityDescription: nil)

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
}
