//
//  AuthorizationService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit

/// @mockable
protocol AuthorizationServiceProtocol {
    // MARK: - Events
    var authorizationStatusForEvent: EKAuthorizationStatus { get }
    func requestAccessToEvents() async throws
}

final class AuthorizationService: AuthorizationServiceProtocol {
    // MARK: - Events
    var authorizationStatusForEvent: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    func requestAccessToEvents() async throws {
        try await EKEventStore().requestFullAccessToEvents()
    }
}
