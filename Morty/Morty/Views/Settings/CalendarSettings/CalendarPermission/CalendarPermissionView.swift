//
//  CalendarPermissionView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct CalendarPermissionView: View {
    let viewModel = CalendarPermissionViewModel()

    var body: some View {
        HStack(alignment: .top) {
            Text("Permissions:")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text("Allow this app to use your calendar.")

                Button {
                    Task {
                        await viewModel.allowButtonPressed()
                    }
                } label: {
                    Text(viewModel.allowButtonTitle)
                }
                .disabled(!viewModel.allowButtonEnabled)
            }
        }
    }
}

#Preview {
    CalendarPermissionView()
}
