//
//  Calendar+Weekdays.swift
//  Morty
//
//  Created by Ezequiel Becerra on 06/11/2022.
//

import Foundation

extension Calendar {
    var yesterday: Date? {
        dateByAdding(days: -1, to: Date())
    }

    var previousWeekday: Date? {
        followingWeekday(startDate: Date(), forward: false)
    }

    var nextWeekday: Date? {
        followingWeekday(startDate: Date(), forward: true)
    }

    /// Get a Date from another date before / after  X day(s)
    func dateByAdding(days: Int, to date: Date) -> Date? {
        var components = DateComponents()
        components.day = days

        return self.date(byAdding: components, to: date)
    }

    /// Get the next / previous following weekday from startDate
    func followingWeekday(startDate: Date, forward: Bool) -> Date? {
        let days: [Int] = forward ? [1, 2, 3] : [-1, -2, -3]

        for offset in days.enumerated() {
            if let date = dateByAdding(days: offset.element, to: startDate) {
                if !date.isWeekend {
                    return date
                }
            }
        }
        return nil
    }
}
