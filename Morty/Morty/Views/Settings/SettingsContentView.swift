//
//  SettingsView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct SettingsContentView: View {
    var body: some View {
        TabView {
            Tab("Calendars", systemImage: "calendar") {
                CalendarSettingsView()
            }

            Tab("Preferences", systemImage: "star") {
                Text("Preferences")
            }
        }
        .scenePadding()
        .frame(maxWidth: 500, minHeight: 200)
    }
}

#Preview {
    SettingsContentView()
}
