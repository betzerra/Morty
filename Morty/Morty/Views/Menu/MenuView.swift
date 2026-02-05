//
//  MenuView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import Factory
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
            copyStandupButton {
                viewModel.previousDayViewModel.copyStandupButtonPressed()
            }
            .disabled(viewModel.previousDayViewModel.copyStandupDisabled)
            Divider()

            // Today
            DayView(viewModel: viewModel.currentDayViewModel)
            copyStandupButton {
                viewModel.currentDayViewModel.copyStandupButtonPressed()
            }
            .disabled(viewModel.currentDayViewModel.copyStandupDisabled)
            Divider()

            // Next day
            DayView(viewModel: viewModel.nextDayViewModel)
            copyStandupButton {
                viewModel.nextDayViewModel.copyStandupButtonPressed()
            }
            .disabled(viewModel.nextDayViewModel.copyStandupDisabled)
        }
        .padding()
    }

    @ViewBuilder
    private func copyStandupButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Label {
                Text("Copy standup")
            } icon: {
                Image(systemName: "doc.on.clipboard.fill")
            }
        }
        .buttonStyle(.borderless)
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
    Container.shared.eventService.preview {
        let mock = EventServiceProtocolMock()
        mock.fetchEventsHandler = {
            Event.mockDay()
        }
        return mock
    }
    MenuView()
}
