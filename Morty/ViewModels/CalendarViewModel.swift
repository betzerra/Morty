//
//  CalendarViewModel.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import Combine
import Foundation

class CalendarViewModel {
    weak var view: CalendarView?
    var cancellables = [AnyCancellable]()

    init(view: CalendarView?, eventsPublisher: AnyPublisher <[Event], Never>) {
        self.view = view

        eventsPublisher
            .print()
            .sink { events in
                view?.update(with: Array(events.prefix(5)))
            }
            .store(in: &cancellables)
    }
}
