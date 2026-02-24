//
//  ReminderTests.swift
//  Morty
//
//  Created by Ezequiel Becerra on 24/02/2026.
//

@testable import Morty

import Foundation
import Testing

struct ReminderTests {
    @Test("Test blocked emoji -> 🛑")
    func blockedEmoji() {
        let reminder = Reminder(
            id: UUID().uuidString,
            title: "Ticket 12345 - Implement Reminders (Blocked)",
            notes: nil,
            isCompleted: false
        )
        #expect(reminder.standupText == "🛑 Ticket 12345 - Implement Reminders (Blocked)")
    }

    @Test(
        "Test bug emoji -> 🐛",
        arguments: [
            "Ticket 12346 - Bug: Crash at startup",
            "Ticket 12347 - Fix: Performance issue when syncing"
        ])
    func bugEmoji(title: String) {
        let reminder = Reminder(
            id: UUID().uuidString,
            title: title,
            notes: nil,
            isCompleted: false
        )
        #expect(reminder.standupText.contains("🐛"))
    }

    @Test(
        "Test completed emoji -> ✅",
        arguments: [
            "Ticket 12346 - Bug: Crash at startup",
            "Ticket 12345 - Implement Reminders (Blocked)",
            "Ticket 12347 - Feature: Setting screen"
        ]
    )
    func completedEmoji(title: String) {
        let reminder = Reminder(
            id: UUID().uuidString,
            title: title,
            notes: nil,
            isCompleted: true
        )
        #expect(reminder.standupText.contains("✅"))
    }

    @Test(
        "Default emoji -> 📝",
        arguments: [
            "Ticket 12347 - Feature: Setting screen"
        ]
    )
    func defaultEmoji(title: String) {
        let reminder = Reminder(
            id: UUID().uuidString,
            title: title,
            notes: nil,
            isCompleted: false
        )
        #expect(reminder.standupText.contains("📝"))
    }
}
