//
//  Calendar+Weekdays.swift
//  Morty
//
//  Created by Ezequiel Becerra on 06/11/2022.
//

import Foundation

extension Calendar {
    var previousWeekday: Date? {
        for offset in [-1, -2, -3].enumerated() {
            if let date = dateByAdding(days: offset.element, to: Date()) {
                if !date.isWeekend {
                    return date
                }
            }
        }
        return nil
    }

    var nextWeekday: Date? {
        for offset in [1, 2, 3].enumerated() {
            if let date = dateByAdding(days: offset.element, to: Date()) {
                if !date.isWeekend {
                    return date
                }
            }
        }
        return nil
    }

    func dateByAdding(days: Int, to date: Date) -> Date? {
        var components = DateComponents()
        components.day = days

        return self.date(byAdding: components, to: date)
    }
}
