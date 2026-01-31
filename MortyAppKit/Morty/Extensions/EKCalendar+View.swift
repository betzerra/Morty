//
//  EKCalendar+View.swift
//  Morty
//
//  Created by Ezequiel Becerra on 23/10/2021.
//

import Foundation
import EventKit

extension EKCalendar {
    var displayTitle: String {
        if source.title.isEmpty {
            return title
        } else {
            return "\(source.title) - \(title)"
        }
    }

    var attributedTitle: NSAttributedString {
        NSAttributedString(
            string: displayTitle,
            attributes: [.foregroundColor: color ?? .textColor]
        )
    }
}
