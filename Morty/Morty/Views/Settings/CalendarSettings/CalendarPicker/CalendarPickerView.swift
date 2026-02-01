//
//  CalendarPickerView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct CalendarPickerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Permissions:")
                .font(.headline)

            Text("Pick the calendars you want to integrate with Morty")
        }
    }
}

#Preview {
    CalendarPickerView()
}
