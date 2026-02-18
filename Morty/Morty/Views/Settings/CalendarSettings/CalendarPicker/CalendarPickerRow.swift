//
//  CalendarPickerRow.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import SwiftUI

struct CalendarPickerRow: View {
    let item: CalendarItem
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")

            Text(item.displayName)
                .foregroundStyle(Color(cgColor: item.color))
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#Preview("Selected") {
    let color = CGColor(
        red: 1,
        green: 45/255.0,
        blue: 224/255.0,
        alpha: 1
    )

    let item = CalendarItem(
        id: UUID().uuidString,
        title: "Ezequiel Becerra",
        source: "iCloud",
        color: color
    )

    CalendarPickerRow(item: item, isSelected: true)
}

#Preview("Not Selected") {
    let color = CGColor(
        red: 1,
        green: 45/255.0,
        blue: 224/255.0,
        alpha: 1
    )

    let item = CalendarItem(
        id: UUID().uuidString,
        title: "Ezequiel Becerra",
        source: "iCloud",
        color: color
    )

    return CalendarPickerRow(item: item, isSelected: false)
}
