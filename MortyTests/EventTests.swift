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
            
            XCTFail()
            return
        }
        
        XCTAssertEqual(event.date.timeIntervalSince1970, 1622912618)
        XCTAssertEqual(event.title, "Super Secret Meeting")
        XCTAssertEqual(event.type, .meeting)
    }
}
