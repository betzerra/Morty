//
//  EventTests.swift
//  MortyTests
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import XCTest
@testable import Morty

class EventTests: XCTestCase {

    func testEventDecode() {
        let bundle = Bundle(for: EventTests.self)

        guard let event: Event = try? bundle.content(fromFileName: "Event_mock_001") else {

            XCTFail("Couldn't parse mock file")
            return
        }

        XCTAssertEqual(event.date.timeIntervalSince1970, 1622912618)
        XCTAssertEqual(event.title, "Super Secret Meeting")
        XCTAssertEqual(event.type, .meeting)
    }

    func testEventsProcessing() {
        let bundle = Bundle(for: EventTests.self)

        guard let events: [Event] = try? bundle.content(fromFileName: "Array_events_mock_001") else {

            XCTFail("Couldn't parse mock file")
            return
        }

        let text = EventsHelper.standupText(from: events)
        let expected = """
        05/06/2021\n📞 14:03 - 1\n📞 15:03 - 2\n\n06/06/2021\n📞 14:03 - 3\n\n
        """

        XCTAssertEqual(text, expected)
    }
}
