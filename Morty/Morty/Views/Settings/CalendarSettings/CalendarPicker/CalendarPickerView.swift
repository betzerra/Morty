//
//  CalendarPickerView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct CalendarPickerView: View {
    @State var selectedCalendars = Set<String>()

    let viewModel = CalendarPickerViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Calendars")
                .font(.headline)

            Text("Pick the calendars you want to integrate with Morty")

            List(viewModel.calendars) { item in
                CalendarPickerRow(
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

    func calendarSelected(_ item: CalendarItem) {
        if isCalendarSelected(item.id) {
            selectedCalendars.remove(item.id)
        } else {
            selectedCalendars.insert(item.id)
        }
    }
}

#Preview {
    CalendarPickerView()
}
