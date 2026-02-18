//
//  EKPermissionViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit
import Factory
import SwiftUI

/// EventKitpermissionViewModel, handles buttons and text for
/// reminders and calendars permissions
@Observable @MainActor final class EKPermissionViewModel {
    private var ekService = Container.shared.eventKitService()

    var type: EKEntityType
    var subtitle: String = ""
    var allowButtonTitle: String = ""
    var allowButtonEnabled: Bool = false

    init(type: EKEntityType) {
        self.type = type

        switch type {
        case .event:
            subtitle = String(localized: "permissions.subtitle.events")
        case .reminder:
            subtitle = String(localized: "permissions.subtitle.reminder")
        @unknown default:
            fatalError("Unsupported type")
        }

        let status = ekService.authorizationStatus(for: self.type)
        updateAllowButton(with: status)
    }

    func allowButtonPressed() async {
        print("allowButtonPressed")
        do {
            try await ekService.requestAccess(to: self.type)

            let newStatus = ekService.authorizationStatus(for: self.type)
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
