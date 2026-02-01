//
//  Services+Injected.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Factory

extension Container {
    var authorizationService: Factory<AuthorizationServiceProtocol> {
        Factory(self) { @MainActor in
            AuthorizationService() as AuthorizationServiceProtocol
        }
        .singleton
    }
}
