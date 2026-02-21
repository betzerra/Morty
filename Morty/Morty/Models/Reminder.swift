//
//  Reminder.swift
//  Morty
//
//  Created by Ezequiel Becerra on 20/02/2026.
//

struct Reminder: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let notes: String?
    let isCompleted: Bool
}
