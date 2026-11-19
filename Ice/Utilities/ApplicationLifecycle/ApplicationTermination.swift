//
//  ApplicationTermination.swift
//  Ice
//

import Foundation

/// Requests a graceful quit without forcing an application to discard its work.
@MainActor
enum ApplicationTermination {
    enum TerminationError: Error {
        case refused
        case timedOut
    }

    static func request(
        isTerminated: () -> Bool,
        terminate: () -> Bool,
        attempts: Int = 50,
        wait: () async throws -> Void = { try await Task.sleep(for: .milliseconds(100)) }
    ) async throws {
        try Task.checkCancellation()
        guard !isTerminated() else {
            return
        }
        guard terminate() || isTerminated() else {
            throw TerminationError.refused
        }
        for _ in 0..<max(0, attempts) {
            try Task.checkCancellation()
            if isTerminated() {
                return
            }
            try await wait()
        }
        try Task.checkCancellation()
        guard isTerminated() else {
            throw TerminationError.timedOut
        }
    }
}
