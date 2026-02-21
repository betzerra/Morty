//
//  ReminderView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 20/02/2026.
//

import SwiftUI

struct ReminderView: View {
    let reminder: Reminder

    private let titleLimit: Int = 30

    init(_ reminder: Reminder) {
        self.reminder = reminder
    }

    var body: some View {
        Label {
            Text(reminder.title.truncated(to: titleLimit))
        } icon: {
            Image(systemName: "circle")
        }
        .foregroundStyle(.tertiary)
    }
}
