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

    var weekday: String {
        let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekdayIndex]
    }
}
