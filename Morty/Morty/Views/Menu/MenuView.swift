//
//  MenuView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.openSettings) private var openSettings

    @State var viewModel = MenuViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            settingsButton
            Divider()

            // Previous day
            DayView(viewModel: viewModel.previousDayViewModel)
            Divider()

            // Today
            DayView(viewModel: viewModel.currentDayViewModel)
            Divider()

            // Next day
            DayView(viewModel: viewModel.nextDayViewModel)
        }
        .padding()
        .onAppear {
            viewModel.refresh()
        }
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
