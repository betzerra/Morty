//
//  PreferencesViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/02/2026.
//

import Factory
import Foundation
import SwiftUI

@MainActor @Observable
final class PreferencesViewModel {
    var filterOnePersonMeetings: Bool {
        get { defaultsService.filterOnePersonMeetings }
        set { defaultsService.filterOnePersonMeetings = newValue }
    }

    private var defaultsService = Container.shared.defaultsService()
}
