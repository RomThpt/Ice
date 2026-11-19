//
//  MenuBarDisplayIdentifierTests.swift
//  Ice
//

@testable import IceDisplay
import Foundation
import Testing

struct MenuBarDisplayIdentifierTests {
    private let uuid = UUID(uuidString: "37D8832A-2D66-02CA-B9F7-8F30A301B230")!

    @Test func mainSentinelSelectsMainDisplayRatherThanFirstDisplay() {
        let result = MenuBarDisplayIdentifier.resolve("Main", mainDisplayID: 2, activeDisplayIDs: [1, 2]) { _ in
            Issue.record("Main must not be parsed as a UUID")
            return nil
        }
        #expect(result == 2)
    }

    @Test func mainSentinelDoesNotSelectAnInactiveDisplay() {
        #expect(MenuBarDisplayIdentifier.resolve("Main", mainDisplayID: 2, activeDisplayIDs: [1]) { _ in uuid } == nil)
    }

    @Test func uuidSelectsSecondaryDisplay() {
        let result = MenuBarDisplayIdentifier.resolve(uuid.uuidString.lowercased(), mainDisplayID: 1, activeDisplayIDs: [1, 2]) {
            $0 == 2 ? uuid : nil
        }
        #expect(result == 2)
    }

    @Test func unmatchedUUIDDoesNotFallBackToMainDisplay() {
        #expect(MenuBarDisplayIdentifier.resolve(uuid.uuidString, mainDisplayID: 1, activeDisplayIDs: [1]) { _ in nil } == nil)
    }

    @Test(arguments: ["", "main", "invalid", "37D8832A"])
    func invalidIdentifierDoesNotFallBackToMainDisplay(_ identifier: String) {
        #expect(MenuBarDisplayIdentifier.resolve(identifier, mainDisplayID: 1, activeDisplayIDs: [1]) { _ in uuid } == nil)
    }

    @Test func noActiveDisplaysReturnsNil() {
        #expect(MenuBarDisplayIdentifier.resolve("Main", mainDisplayID: 1, activeDisplayIDs: []) { _ in uuid } == nil)
    }
}
