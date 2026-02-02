//
//  CalendarPermissionViewModelTests.swift
//  Morty
//
//  Created by Ezequiel Becerra on 31/01/2026.
//

import EventKit
import Factory
import Foundation
import Testing

@testable import Morty

@MainActor
struct CalendarPermissionViewModelTests {
    let eventsServiceMock: EventsServiceProtocolMock

    init() {
        let serviceMock = EventsServiceProtocolMock()
        Container.shared.eventsService.register { @MainActor in
            serviceMock
        }

        eventsServiceMock = serviceMock
    }

    @Test(
        "Test view model properties when authorization is not yet given",
        arguments: [EKAuthorizationStatus.notDetermined, EKAuthorizationStatus.writeOnly]
    )
    func authorizationNotDetermined(status: EKAuthorizationStatus) async {
        eventsServiceMock.authorizationStatusForEvent = status

        let viewModel = CalendarPermissionViewModel()
        #expect(viewModel.allowButtonEnabled)
        #expect(viewModel.allowButtonTitle == "Allow")
        #expect(eventsServiceMock.requestAccessToEventsCallCount == 0)

        await viewModel.allowButtonPressed()
        #expect(eventsServiceMock.requestAccessToEventsCallCount == 1)
    }

    @Test("Test view model properties when authorization is granted")
    func authorizationAllowed() async {
        eventsServiceMock.authorizationStatusForEvent = .fullAccess

        let viewModel = CalendarPermissionViewModel()
        #expect(viewModel.allowButtonEnabled == false)
        #expect(viewModel.allowButtonTitle == "Granted")
    }

    @Test(
        "Test view model properties when authorization can't be given",
        arguments: [EKAuthorizationStatus.denied, EKAuthorizationStatus.restricted]
    )
    func authorizationFailed(status: EKAuthorizationStatus) async {
        eventsServiceMock.authorizationStatusForEvent = status

        let viewModel = CalendarPermissionViewModel()
        #expect(viewModel.allowButtonEnabled == false)
        #expect(viewModel.allowButtonTitle == "Denied")
    }
}
