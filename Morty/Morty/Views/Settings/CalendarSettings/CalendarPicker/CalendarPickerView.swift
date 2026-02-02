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
                row(for: item, isSelected: isCalendarSelected(item.id))
            }
        }
        .onChange(of: selectedCalendars) { _, newValue in
            viewModel.allowedCalendarsChange(newValue)
        }
    }

    @ViewBuilder
    func row(for item: CalendarItem, isSelected: Bool) -> some View {
        HStack {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")

            Text(item.displayName)
                .foregroundStyle(Color(cgColor: item.color))
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            calendarSelected(item)
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
