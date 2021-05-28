//
//  EventsManager.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Foundation
import EventKit

class EventsManager {
    var store = EKEventStore()
    
    func requestAccess(completion: ((Bool, Error) -> ())) {
        store.requestAccess(to: .event) { _, _ in
        }
    }
    
    func fetchEvents() -> [EKEvent] {
        guard let yesterday = dateByAdding(days: -1),
              let tomorrow = dateByAdding(days: 1) else {
            
            return []
        }
        
        let predicate = store.predicateForEvents(
            withStart: yesterday,
            end: tomorrow,
            calendars: nil
        )
        
        return store.events(matching: predicate)
    }
}

fileprivate func dateByAdding(days: Int) -> Date? {
    var components = DateComponents()
    components.day = days
    
    return Calendar.current.date(byAdding: components, to: Date())
}
