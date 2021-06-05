//
//  Event.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import Foundation

enum EventType: String, Codable {
    case meeting
}

struct Event: Codable {
    let date: Date
    let title: String
    let type: EventType
}
