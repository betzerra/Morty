//
//  MenuDayViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 25/10/2021.
//

import Combine
import Foundation

class MenuDayViewModel {

    var cancellables = [AnyCancellable]()

    init(view: MenuDayView, publisher: AnyPublisher<[Day], Never>) {
        publisher.sink { days in
            let events = days.flatMap { $0.events }
            let summary = MenuDayViewModel.summary(from: events)
            view.update(with: events, summary: summary)
        }
        .store(in: &cancellables)
    }

    static func summary(from events: [Event]) -> String {
        let timeSpent = events
            .compactMap { $0.endDate.timeIntervalSince($0.startDate) }
            .reduce(0, { $0 + $1 }) / 3600

        return "\(timeSpent) hours in meetings today"
    }
}
