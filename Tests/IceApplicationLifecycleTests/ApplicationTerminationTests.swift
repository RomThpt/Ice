//
//  ApplicationTerminationTests.swift
//  Ice
//

@testable import IceApplicationLifecycle
import Testing

@MainActor
struct ApplicationTerminationTests {
    @Test func alreadyTerminatedDoesNotSendQuit() async throws {
        var requests = 0
        try await ApplicationTermination.request(
            isTerminated: { true },
            terminate: { requests += 1; return true },
            wait: { Issue.record("Already terminated application must not be waited on") }
        )
        #expect(requests == 0)
    }

    @Test func waitsForGracefulTermination() async throws {
        var requests = 0
        var waits = 0
        try await ApplicationTermination.request(
            isTerminated: { waits == 2 },
            terminate: { requests += 1; return true },
            wait: { waits += 1 }
        )
        #expect(requests == 1)
        #expect(waits == 2)
    }

    @Test func refusalLeavesApplicationRunning() async {
        var waits = 0
        await #expect(throws: ApplicationTermination.TerminationError.refused) {
            try await ApplicationTermination.request(
                isTerminated: { false },
                terminate: { false },
                wait: { waits += 1 }
            )
        }
        #expect(waits == 0)
    }

    @Test func acceptedQuitCannotHangIndefinitely() async {
        var requests = 0
        var waits = 0
        await #expect(throws: ApplicationTermination.TerminationError.timedOut) {
            try await ApplicationTermination.request(
                isTerminated: { false },
                terminate: { requests += 1; return true },
                attempts: 3,
                wait: { waits += 1 }
            )
        }
        #expect(requests == 1)
        #expect(waits == 3)
    }

    @Test func terminationAtDeadlineSucceeds() async throws {
        var waits = 0
        try await ApplicationTermination.request(
            isTerminated: { waits == 3 },
            terminate: { true },
            attempts: 3,
            wait: { waits += 1 }
        )
        #expect(waits == 3)
    }

    @Test func concurrentExitAfterRefusalSucceeds() async throws {
        var exited = false
        try await ApplicationTermination.request(
            isTerminated: { exited },
            terminate: { exited = true; return false },
            wait: { Issue.record("Exited application must not be waited on") }
        )
    }

    @Test func cancellationBeforeRequestDoesNotQuit() async {
        var requests = 0
        let task = Task { @MainActor in
            try await ApplicationTermination.request(
                isTerminated: { false },
                terminate: { requests += 1; return true }
            )
        }
        task.cancel()
        await #expect(throws: CancellationError.self) {
            try await task.value
        }
        #expect(requests == 0)
    }

    @Test func cancellationDuringWaitPropagates() async {
        var requests = 0
        await #expect(throws: CancellationError.self) {
            try await ApplicationTermination.request(
                isTerminated: { false },
                terminate: { requests += 1; return true },
                wait: { throw CancellationError() }
            )
        }
        #expect(requests == 1)
    }
}
