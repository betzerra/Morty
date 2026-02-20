//
//  SettingsView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit
import SwiftUI

struct SettingsContentView: View {
    var body: some View {
        TabView {
            Tab("Calendars", systemImage: "calendar") {
                EKCalendarSettingsView(type: .event)
            }

            Tab("Reminders", systemImage: "checklist") {
                EKCalendarSettingsView(type: .reminder)
            }

            Tab("Preferences", systemImage: "star") {
                PreferencesView()
            }
        }
        .scenePadding()
        .frame(maxWidth: 500, minHeight: 400)
    }
}

#Preview {
    SettingsContentView()
}
