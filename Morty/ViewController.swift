//
//  ViewController.swift
//  Morty
//
//  Created by Ezequiel Becerra on 27/05/2021.
//

import Cocoa
import EventKit

class ViewController: NSViewController {
    var store = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request access to reminders.
        store.requestAccess(to: .event) { granted, error in
            // Handle the response to the request.
            print("Hello world")
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

    @IBAction func fetchEvents(_ sender: Any) {
        let events = fetchEvents()
        print(events)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

fileprivate func dateByAdding(days: Int) -> Date? {
    var components = DateComponents()
    components.day = days
    
    return Calendar.current.date(byAdding: components, to: Date())
}

