//
//  EventViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//
import SwiftUI
@MainActor @Observable
final class EventViewModel {
    let event: Event

    private let titleLimit: Int = 30

    init(event: Event) {
        self.event = event
    }

    var title: String {
        switch event.type {
        case .meeting, .onePerson:
            return "\(event.startDate.time) - \(event.title.truncated(to: titleLimit))"

        case .allDay:
            return event.title.truncated(to: titleLimit)
        }
    }

    var imageName: String {
        switch event.type {
        case .allDay:
            "calendar"

        case .meeting:
            "phone"

        case .onePerson:
            "person"
        }
    }
}
