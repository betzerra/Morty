//
//  Services+Injected.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Factory

extension Container {
    var calendarService: Factory<CalendarServiceProtocol> {
        Factory(self) { @MainActor in
            CalendarService() as CalendarServiceProtocol
        }
        .singleton
    }

    var eventsService: Factory<EventsServiceProtocol> {
        Factory(self) { @MainActor in
            EventsService() as EventsServiceProtocol
        }
        .singleton
    }
}
