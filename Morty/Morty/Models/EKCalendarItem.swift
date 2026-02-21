//
//  EKCalendarItem.swift
//  Morty
//
//  Created by Ezequiel Becerra on 20/02/2026.
//

import EventKit
import SwiftUI

struct EKCalendarItem: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let source: String
    let color: CGColor
    let entityType: EKEntityType

    var displayName: String {
        [source, title]
            .filter { !$0.isEmpty}
            .joined(separator: " - ")
    }
}
