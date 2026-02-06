//
//  PreferencesView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/02/2026.
//

import SwiftUI

struct PreferencesView: View {
    @State var viewModel = PreferencesViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text("Preferences")
                .font(.headline)

            filterOnePersonMeetingsToggle

            Spacer()
        })
    }

    @ViewBuilder
    private var filterOnePersonMeetingsToggle: some View {
        VStack(alignment: .leading, content: {
            Toggle(
                "Filter 1-person-meetings in clipboard",
                isOn: $viewModel.filterOnePersonMeetings
            )
            .toggleStyle(.checkbox)

            Text("""
                Many people book meetings for themselves to block time into their calendars. Enabling this won't copy those meetings in the daily standup.
                """)
            .foregroundStyle(.secondary)
            .lineLimit(2)
        })
    }
}

#Preview {
    PreferencesView()
        .padding()
}
