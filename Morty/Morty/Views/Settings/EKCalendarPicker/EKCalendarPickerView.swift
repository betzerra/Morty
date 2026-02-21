//
//  EKCalendarPickerView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit
import SwiftUI

struct EKCalendarPickerView: View {
    @State var selectedCalendars = Set<String>()

    let viewModel: EKCalendarPickerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.title)
                .font(.headline)

            Text(viewModel.subtitle)

            List(viewModel.calendars) { item in
                EKCalendarPickerRow(
                    item: item,
                    isSelected: isCalendarSelected(item.id)
                )
                .onTapGesture {
                    calendarSelected(item)
                }
            }
        }
        .onAppear(perform: {
            selectedCalendars = viewModel.allowedCalendars
        })
        .onChange(of: selectedCalendars) { _, newValue in
            viewModel.allowedCalendarsChange(newValue)
        }
    }

    func isCalendarSelected(_ id: String) -> Bool {
        selectedCalendars.contains(id)
    }

    func calendarSelected(_ item: EKCalendarItem) {
        if isCalendarSelected(item.id) {
            selectedCalendars.remove(item.id)
        } else {
            selectedCalendars.insert(item.id)
        }
    }
}

#Preview {
    let viewModel = EKCalendarPickerViewModel(type: .event)
    EKCalendarPickerView(viewModel: viewModel)
}
