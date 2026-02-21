//
//  Reminder+Mock.swift
//  Morty
//
//  Created by Ezequiel Becerra on 21/02/2026.
//

import Foundation

extension Reminder {
    static func mock(title: String, notes: String?) -> Self {
        Reminder(
            id: UUID().uuidString,
            title: title,
            notes: notes,
            isCompleted: false
        )
    }

    static func mockSet() -> [Self] {
        [
            Reminder(
                id: UUID().uuidString,
                title: "Fix important bug on Settings",
                notes: "There's a bug on the settings screen that crashes the app",
                isCompleted: false
            ),
            Reminder(
                id: UUID().uuidString,
                title: "Unit Tests",
                notes: nil,
                isCompleted: false
            ),
            Reminder(
                id: UUID().uuidString,
                title: "Release v2.0",
                notes: nil,
                isCompleted: true
            )
        ]
    }
}
