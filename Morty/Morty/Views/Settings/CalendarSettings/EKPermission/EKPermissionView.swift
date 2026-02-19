//
//  CalendarPermissionView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit
import SwiftUI

struct EKPermissionView: View {
    let viewModel: EKPermissionViewModel

    var body: some View {
        HStack(alignment: .top) {
            Text("Permissions:")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.subtitle)

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
    let viewModel = EKPermissionViewModel(type: .event)
    EKPermissionView(viewModel: viewModel)
}
