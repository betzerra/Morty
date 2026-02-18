//
//  CalendarSettingsView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit
import SwiftUI

struct CalendarSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            EKPermissionView(viewModel: EKPermissionViewModel(type: .event))

            Divider()

            CalendarPickerView()
        }
    }
}

#Preview {
    CalendarSettingsView()
}
