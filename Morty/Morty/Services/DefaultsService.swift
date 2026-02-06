//
//  DefaultsService.swift
//  Morty
//
//  Created by Ezequiel Becerra on 04/02/2026.
//

import Foundation

/// @mockable
protocol DefaultsServiceProtocol {
    var allowedCalendars: [String] { get set }
    var filterOnePersonMeetings: Bool { get set }
}

final class DefaultsService: DefaultsServiceProtocol {
    var allowedCalendars: [String] {
        get { DefaultsService.loadValue(forKey: .allowedCalendars) ?? [] }
        set { DefaultsService.saveValue(setting: newValue, forKey: .allowedCalendars) }
    }

    var filterOnePersonMeetings: Bool {
        get { DefaultsService.loadValue(forKey: .filterOnePersonMeetings) ?? false }
        set { DefaultsService.saveValue(setting: newValue, forKey: .filterOnePersonMeetings) }
    }

    // Try to keep all the keys sorted alphabetically :-)
    enum Key: String {
        case allowedCalendars
        case filterOnePersonMeetings
    }

    /// Load from disk a setting value previously saved.
    private static func loadValue<T: Codable>(forKey key: DefaultsService.Key) -> T? {
        guard let encoded = UserDefaults.standard.object(forKey: key.rawValue) as? Data else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: encoded)
    }

    /// Save to disk a setting value.
    private static func saveValue<T: Codable>(setting: T?, forKey key: DefaultsService.Key) {
        guard let value = setting else {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
            return
        }

        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
    }

}
