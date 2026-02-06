//
//  CalendarPermissionViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit
import Factory
import SwiftUI

@Observable @MainActor final class CalendarPermissionViewModel {
    private var eventsService = Container.shared.eventKitService()

    var allowButtonTitle: String = ""
    var allowButtonEnabled: Bool = false

    init() {
        let status = eventsService.authorizationStatusForEvent
        updateAllowButton(with: status)
    }

    func allowButtonPressed() async {
        print("allowButtonPressed")
        do {
            try await eventsService.requestAccessToEvents()

            let newStatus = eventsService.authorizationStatusForEvent
            updateAllowButton(with: newStatus)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }

    private func updateAllowButton(with status: EKAuthorizationStatus) {
        self.allowButtonTitle = Self.buttonTitle(for: status)
        self.allowButtonEnabled = Self.buttonEnabled(for: status)
    }

    private static func buttonTitle(for status: EKAuthorizationStatus) -> String {
        switch status {
        case .denied, .restricted:
            return String(localized: "denied").localizedCapitalized
        case .fullAccess:
            return String(localized: "granted").localizedCapitalized
        case .notDetermined, .writeOnly:
            return String(localized: "allow").localizedCapitalized
        @unknown default:
            return String(localized: "N/A")
        }
    }

    private static func buttonEnabled(for status: EKAuthorizationStatus) -> Bool {
        switch status {
        case .notDetermined, .writeOnly:
            true
        case .restricted, .denied, .fullAccess:
            false
        @unknown default:
            true
        }
    }
}
