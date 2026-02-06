//
//  TimeFormatterTests.swift
//  MortyTests
//
//  Created by Ezequiel Becerra on 07/11/2021.
//

import XCTest
@testable import Morty

class TimeFormatterTests: XCTestCase {

    func testTimeSpentFormatHourComponent() {
        var target = TimeFormatter.string(fromSeconds: 3600)
        XCTAssertEqual(target, "1h")

        // Added a few seconds, but should return 1h anyways
        target = TimeFormatter.string(fromSeconds: 3630)
        XCTAssertEqual(target, "1h")

        target = TimeFormatter.string(fromSeconds: 7200)
        XCTAssertEqual(target, "2h")
    }

    func testTimeSpentFormatMinuteComponent() {
        var target = TimeFormatter.string(fromSeconds: 60)
        XCTAssertEqual(target, "1m")

        // Added a few seconds, but should return 1m anyways
        target = TimeFormatter.string(fromSeconds: 65)
        XCTAssertEqual(target, "1m")

        target = TimeFormatter.string(fromSeconds: 300)
        XCTAssertEqual(target, "5m")

        target = TimeFormatter.string(fromSeconds: 900)
        XCTAssertEqual(target, "15m")

        // Added a few seconds, but should return 15m anyways
        target = TimeFormatter.string(fromSeconds: 929)
        XCTAssertEqual(target, "15m")

        // Rounds to 16m after 30 seconds
        target = TimeFormatter.string(fromSeconds: 930)
        XCTAssertEqual(target, "16m")

        // on the other hand... hour component doesn't round
        target = TimeFormatter.string(fromSeconds: 3550)
        XCTAssertEqual(target, "59m")
    }

    func testTimeSpentFormatHourAndMinuteComponent() {
        var target = TimeFormatter.string(fromSeconds: 3660)
        XCTAssertEqual(target, "1h 1m")

        target = TimeFormatter.string(fromSeconds: 5400)
        XCTAssertEqual(target, "1h 30m")

        target = TimeFormatter.string(fromSeconds: 9000)
        XCTAssertEqual(target, "2h 30m")
    }
}
