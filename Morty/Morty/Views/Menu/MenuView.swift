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
            if viewModel.previousDayViewModel.copyStandupEnabled {
                copyStandupButton {
                    viewModel.previousDayViewModel.copyStandupButtonPressed()
                }
            }
            Divider()

            // Today
            DayView(viewModel: viewModel.currentDayViewModel)
            if viewModel.currentDayViewModel.copyStandupEnabled {
                copyStandupButton {
                    viewModel.currentDayViewModel.copyStandupButtonPressed()
                }
            }
            Divider()

            // Next day
            DayView(viewModel: viewModel.nextDayViewModel)
            if viewModel.nextDayViewModel.copyStandupEnabled {
                copyStandupButton {
                    viewModel.nextDayViewModel.copyStandupButtonPressed()
                }
            }
            Divider()

            // Quit
            quitButton
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
    private var quitButton: some View {
        Button {
            NSApp.terminate(nil)
        } label: {
            Label {
                Text("Quit")
            } icon: {
                Image(systemName: "xmark.rectangle")
            }

        }
        .keyboardShortcut("q", modifiers: .command)
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
        mock.events = Event.mockDay()
        return mock
    }
    MenuView()
        .padding(.vertical)
}
