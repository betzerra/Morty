//
//  Event+Mock.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Foundation

extension Event {
    static func mock(title: String, type: EventType) -> Self {
        Event(
            id: UUID().uuidString,
            startDate: Date(timeIntervalSinceNow: -60*60*24),
            endDate: Date(timeIntervalSinceNow: -60*60*23),
            title: title,
            type: type
        )
    }
}
