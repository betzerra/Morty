//
//  Date+Calendar.swift
//  Morty
//
//  Created by Ezequiel Becerra on 06/11/2022.
//

import Foundation

extension Date {
    var isWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
}
