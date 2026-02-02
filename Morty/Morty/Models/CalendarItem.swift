//
//  Calendar.swift
//  Morty
//
//  Created by Ezequiel Becerra on 01/02/2026.
//

import SwiftUI

struct CalendarItem: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let source: String
    let color: CGColor

    var displayName: String {
        [source, title]
            .filter { !$0.isEmpty}
            .joined(separator: " - ")
    }
}
