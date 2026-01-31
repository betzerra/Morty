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
            DayView(viewModel: DayViewModel(events: [
                Event.mock(title: "Mom's Birthday", type: .allDay),
                Event.mock(title: "All Hands", type: .meeting),
                Event.mock(title: "Focus Time", type: .onePerson)
            ]))
        }
    }
}

#Preview {
    MenuView()
}
