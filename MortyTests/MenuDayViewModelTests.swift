//
//  MenuDayViewModelTests.swift
//  MortyTests
//
//  Created by Ezequiel Becerra on 07/11/2021.
//

import XCTest
@testable import Morty

class MenuDayViewModelTests: XCTestCase {

    func testTimeSpentFormatHourComponent() {
        var target = MenuDayViewModel.timeSpentFormatted(from: 3600)
        XCTAssertEqual(target, "1h")

        // Added a few seconds, but should return 1h anyways
        target = MenuDayViewModel.timeSpentFormatted(from: 3630)
        XCTAssertEqual(target, "1h")

        target = MenuDayViewModel.timeSpentFormatted(from: 7200)
        XCTAssertEqual(target, "2h")
    }

    func testTimeSpentFormatMinuteComponent() {
        var target = MenuDayViewModel.timeSpentFormatted(from: 60)
        XCTAssertEqual(target, "1m")

        // Added a few seconds, but should return 1m anyways
        target = MenuDayViewModel.timeSpentFormatted(from: 65)
        XCTAssertEqual(target, "1m")

        target = MenuDayViewModel.timeSpentFormatted(from: 300)
        XCTAssertEqual(target, "5m")

        target = MenuDayViewModel.timeSpentFormatted(from: 900)
        XCTAssertEqual(target, "15m")

        // Added a few seconds, but should return 15m anyways
        target = MenuDayViewModel.timeSpentFormatted(from: 929)
        XCTAssertEqual(target, "15m")

        // Rounds to 16m after 30 seconds
        target = MenuDayViewModel.timeSpentFormatted(from: 930)
        XCTAssertEqual(target, "16m")

        // on the other hand... hour component doesn't round
        target = MenuDayViewModel.timeSpentFormatted(from: 3550)
        XCTAssertEqual(target, "59m")
    }

    func testTimeSpentFormatHourAndMinuteComponent() {
        var target = MenuDayViewModel.timeSpentFormatted(from: 3660)
        XCTAssertEqual(target, "1h 1m")

        target = MenuDayViewModel.timeSpentFormatted(from: 5400)
        XCTAssertEqual(target, "1h 30m")

        target = MenuDayViewModel.timeSpentFormatted(from: 9000)
        XCTAssertEqual(target, "2h 30m")
    }
}
