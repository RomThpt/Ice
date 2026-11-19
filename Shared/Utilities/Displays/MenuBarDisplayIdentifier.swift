//
//  MenuBarDisplayIdentifier.swift
//  Shared
//

import Foundation

/// Resolves WindowServer's menu bar identifier against the active displays.
enum MenuBarDisplayIdentifier {
    static func resolve(
        _ identifier: String,
        mainDisplayID: UInt32,
        activeDisplayIDs: [UInt32],
        displayUUID: (UInt32) -> UUID?
    ) -> UInt32? {
        // WindowServer can return this sentinel instead of a display UUID.
        if identifier == "Main" {
            return activeDisplayIDs.first { $0 == mainDisplayID }
        }
        guard let uuid = UUID(uuidString: identifier) else {
            return nil
        }
        return activeDisplayIDs.first { displayUUID($0) == uuid }
    }
}
