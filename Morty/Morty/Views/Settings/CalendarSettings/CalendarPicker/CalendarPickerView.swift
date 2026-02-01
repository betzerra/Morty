//
//  CalendarPickerView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct CalendarPickerView: View {
    let viewModel = CalendarPickerViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Calendars")
                .font(.headline)

            Text("Pick the calendars you want to integrate with Morty")

            Table(viewModel.calendars) {
                TableColumn("Calendar") { item in
                    Text(item.displayName)
                        .foregroundStyle(Color(cgColor: item.color))
                }
            }
        }
    }
}

#Preview {
    CalendarPickerView()
}
