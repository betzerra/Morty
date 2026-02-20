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
    func fetchCalendars(type: EKEntityType) -> [EKCalendarItem]
    var allowedCalendars: Set<String> { get set }

    var allowedCalendarsPublisher: AnyPublisher<Set<String>, Never> { get }
}

final class CalendarService: CalendarServiceProtocol {
    private var defaultsService = Container.shared.defaultsService()
    private let eventsService = Container.shared.eventKitService()

    init() {
        allowedCalendarsSubject.value = Set(defaultsService.allowedCalendars)
    }

    var allowedCalendars: Set<String> {
        get {
            allowedCalendarsSubject.value
        }

        set {
            allowedCalendarsSubject.value = newValue
            defaultsService.allowedCalendars = Array(newValue)
        }
    }

    private let allowedCalendarsSubject = CurrentValueSubject<Set<String>, Never>(Set<String>())
    lazy var allowedCalendarsPublisher: AnyPublisher<Set<String>, Never> = {
        allowedCalendarsSubject.eraseToAnyPublisher()
    }()

    func fetchCalendars(type: EKEntityType) -> [EKCalendarItem] {
        eventsService
            .calendars(for: type)
            .map {
                EKCalendarItem(
                    id: $0.calendarIdentifier,
                    title: $0.title,
                    source: $0.source.title,
                    color: $0.cgColor,
                    entityType: type
                )
            }
            .sorted { lhs, rhs in
                return lhs.displayName < rhs.displayName
            }
    }
}
