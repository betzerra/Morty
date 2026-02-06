//
//  EventView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct EventView: View {
    let viewModel: EventViewModel

    var body: some View {
        Label {
            Text(viewModel.title)
        } icon: {
            Image(systemName: viewModel.imageName)
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview("Meeting") {
    let event = Event.mock(title: "Tonchis <> Eze", type: .meeting)
    let viewModel = EventViewModel(event: event)
    EventView(viewModel: viewModel)
        .padding()
}

#Preview("All Day") {
    let event = Event.mock(title: "Eze OOO", type: .allDay)
    let viewModel = EventViewModel(event: event)
    EventView(viewModel: viewModel)
        .padding()
}

#Preview("One Person Event") {
    let event = Event.mock(title: "Focus Time", type: .onePerson)
    let viewModel = EventViewModel(event: event)
    EventView(viewModel: viewModel)
        .padding()
}
