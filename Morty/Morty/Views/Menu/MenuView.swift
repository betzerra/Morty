//
//  MenuView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(alignment: .leading) {
            settingsButton

            Divider()

            DayView(viewModel: DayViewModel(date: Date(), events: Event.mockDay()))
        }
        .padding()
    }

    @ViewBuilder
    private var settingsButton: some View {
        Button {
            openSettings()
        } label: {
            Label {
                Text("Settings...")
            } icon: {
                Image(systemName: "gear")
            }
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    MenuView()
}
