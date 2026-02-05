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
        VStack(alignment: .leading, spacing: 12) {
            title

            if viewModel.events.isEmpty {
                emptyEventList
            } else {
                eventList
            }
        }
    }

    @ViewBuilder
    private var title: some View {
        Text(viewModel.title)
            .font(.headline)
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private var emptyEventList: some View {
        Label {
            Text("No events!")
        } icon: {
            Image(systemName: "gamecontroller")
        }
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private var eventList: some View {
        VStack(alignment: .leading, spacing: 6.0) {
            ForEach(viewModel.events) { event in
                view(event: event)
            }

            if viewModel.timeSpent > 0 {
                summaryView
                    .padding(.top, 6.0)
            }
        }
    }

    @ViewBuilder
    private var summaryView: some View {
        Label {
            Text(viewModel.timeSpentSummary)
        } icon: {
            Image(systemName: "info.circle.fill")
        }
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func view(event: Event) -> some View {
        let viewModel = EventViewModel(event: event)
        EventView(viewModel: viewModel)
    }
}

#Preview("Some Events") {
    let viewModel = DayViewModel(title: "Today", events: Event.mockDay())
    DayView(viewModel: viewModel)
        .padding()
}

#Preview("No Events") {
    let viewModel = DayViewModel(title: "Today", events: [])
    DayView(viewModel: viewModel)
        .padding()
}
