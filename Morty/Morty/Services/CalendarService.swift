//
//  CalendarService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import Combine
import EventKit
import Factory
import Foundation

/// @mockable
protocol CalendarServiceProtocol {
    func fetchCalendars() -> [CalendarItem]
    var allowedCalendars: Set<String> { get set }

    var allowedCalendarsPublisher: AnyPublisher<Set<String>, Never> { get }
}

final class CalendarService: CalendarServiceProtocol {
    private let eventsService = Container.shared.eventKitService()

    var allowedCalendars: Set<String> {
        get {
            allowedCalendarsSubject.value
        }

        set {
            allowedCalendarsSubject.value = newValue
        }
    }

    private let allowedCalendarsSubject = CurrentValueSubject<Set<String>, Never>(Set<String>())
    lazy var allowedCalendarsPublisher: AnyPublisher<Set<String>, Never> = {
        allowedCalendarsSubject.eraseToAnyPublisher()
    }()

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
