//
//  MortyApp.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import SwiftUI

@main
struct MortyApp: App {
    var body: some Scene {
        MenuBarExtra("Morty", systemImage: "tray.fill") {
            MenuView()
        }
    }
}
