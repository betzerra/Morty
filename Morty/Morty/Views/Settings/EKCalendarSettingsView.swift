//
//  CalendarSettingsView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit
import SwiftUI

struct EKCalendarSettingsView: View {
    private let permissionViewModel: EKPermissionViewModel
    private let pickerViewModel: EKCalendarPickerViewModel

    init(type: EKEntityType) {
        permissionViewModel = EKPermissionViewModel(type: type)
        pickerViewModel = EKCalendarPickerViewModel(type: type)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            EKPermissionView(viewModel: permissionViewModel)

            Divider()

            EKCalendarPickerView(viewModel: pickerViewModel)
        }
    }
}

#Preview {
    EKCalendarSettingsView(type: .event)
}
