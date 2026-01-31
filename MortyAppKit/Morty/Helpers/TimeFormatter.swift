//
//  TimeFormatter.swift
//  Morty
//
//  Created by Ezequiel Becerra on 06/11/2022.
//

import Foundation

class TimeFormatter {
    static func string(fromSeconds seconds: Double) -> String {
        var minutes = seconds / 60
        let hours = floor(minutes / 60)

        if hours >= 1.0 {
            minutes -= (hours * 60)
            if minutes >= 1.0 {
                return String(format: "%.0fh %.0fm", hours, minutes)
            } else {
                return String(format: "%.0fh", hours, minutes)
            }
        } else {
            return String(format: "%.0fm", minutes)
        }
    }
}
