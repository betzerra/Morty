//
//  MenuDayView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct DayView: View {
    let viewModel: DayViewModel

    var body: some View {
        if viewModel.events.isEmpty {
            emptyEventList
        } else {
            eventList
        }
    }

    @ViewBuilder
    private var emptyEventList: some View {
        EmptyView()
    }

    @ViewBuilder
    private var eventList: some View {
        VStack(alignment: .leading, spacing: 6.0) {
            ForEach(viewModel.events) { event in
                view(event: event)
            }
        }
    }

    @ViewBuilder
    private func view(event: Event) -> some View {
        let viewModel = EventViewModel(event: event)
        EventView(viewModel: viewModel)
    }
}

#Preview("Some Events") {
    let viewModel = DayViewModel(events: [
        Event.mock(title: "Payday", type: .allDay),
        Event.mock(title: "Tonchis <> Eze", type: .meeting),
        Event.mock(title: "Focus Time", type: .onePerson)
    ])

    DayView(viewModel: viewModel)
        .padding()
}

#Preview("No Events") {
    let viewModel = DayViewModel(events: [])

    DayView(viewModel: viewModel)
        .padding()
}
