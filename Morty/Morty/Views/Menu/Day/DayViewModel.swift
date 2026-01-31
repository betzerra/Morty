//
//  DayViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

@MainActor @Observable
final class DayViewModel {
    let events: [Event]

    init(events: [Event]) {
        self.events = events
    }
}
