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

    var eventService: Factory<EventServiceProtocol> {
        Factory(self) { @MainActor in
            EventService() as EventServiceProtocol
        }
        .singleton
    }

    var eventKitService: Factory<EKServiceProtocol> {
        Factory(self) { @MainActor in
            EKService() as EKServiceProtocol
        }
        .singleton
    }
}
