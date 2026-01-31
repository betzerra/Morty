//
//  MenuView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack {
            DayView(viewModel: DayViewModel(events: []))
        }
    }
}

#Preview {
    MenuView()
}
