//
//  CalendarService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import EventKit
import Factory
import Foundation

/// @mockable
protocol CalendarServiceProtocol {
    func fetchCalendars() -> [CalendarItem]
    var allowedCalendars: Set<String> { get set }
}

final class CalendarService: CalendarServiceProtocol {
    private let eventsService = Container.shared.eventKitService()

    var allowedCalendars = Set<String>()

    func fetchCalendars() -> [CalendarItem] {
        eventsService
            .calendars(for: .event)
            .map {
                CalendarItem(
                    id: $0.calendarIdentifier,
                    title: $0.title,
                    source: $0.source.title,
                    color: $0.cgColor
                )
            }
            .sorted { lhs, rhs in
                return lhs.displayName < rhs.displayName
            }
    }
}
