//
//  DateFormatter+Formats.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import Foundation

extension Date {
    var time: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return formatter.string(from: self)
    }
}
