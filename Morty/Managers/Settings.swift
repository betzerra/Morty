//
//  Settings.swift
//  Morty
//
//  Created by Ezequiel Becerra on 23/10/2021.
//

import Combine
import Foundation

class Settings {
    @Published var enabledCalendars = Set<String>() {
        willSet {
            Settings.saveValue(setting: newValue, forKey: .enabledCalendars)
        }
    }

    var cancellables = [AnyCancellable]()

    // Try to keep all the keys sorted alphabetically :-)
    enum Key: String {
        case enabledCalendars
    }

    // This will force developer to use always Settings.fromUserDefaults()
    private init() {}

    /// Load values from disk to current instance
    public static func fromUserDefaults() -> Settings {
        let settings = Settings()

        if let tmp: Set<String> = Settings.loadValue(forKey: .enabledCalendars) {
            settings.enabledCalendars = tmp
        }

        return settings
    }

    /// Resets values
    public func reset() {
        enabledCalendars = []
    }

    /// Load from disk a setting value previously saved.
    private static func loadValue<T: Codable>(forKey key: Settings.Key) -> T? {
        guard let encoded = UserDefaults.standard.object(forKey: key.rawValue) as? Data else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: encoded)
    }

    /// Save to disk a setting value.
    private static func saveValue<T: Codable>(setting: T?, forKey key: Settings.Key) {
        guard let value = setting else {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
            return
        }

        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
    }

    /// Delete a setting value from disk
    private static func deleteValue(forKey key: Settings.Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
