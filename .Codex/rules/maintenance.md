# Maintenance state

Initial source: jordanbaird/Ice main at
`11edd39115f3f43a83ae114b5348df6a0e1741cf`.

Issue/PR order:

1. #1: repository instructions and verification workflow.
2. #2: temporary capture allocation lifetime.
3. #3: graceful, bounded application relaunch and PID iteration.
4. #4: macOS 26 prerequisite and macOS 27 compatibility integration, including
   build-phase safety and disabling the upstream update channel for this fork.

The first three changes do not establish macOS 27 support. The compatibility
candidate is upstream PR #995 at `889f1ead1fcf79ec74e4314ad107167e17903771`,
based on macos-26 at `6d74d25c33a9ab04307c1f222fbe68ad71847234`.

No application installation or permission grants are part of this work.

## Validation and remaining work

- PR #5: maintenance instructions; PR #6: capture allocation; PR #7: spacing.
- SwiftLint 0.65.1 passes for Ice, Shared, MenuBarItemService and Tests.
- The pure test packages pass 194 tests (186 compatibility + 8 lifecycle).
- Debug compilation passed during integration; the final fork configuration also
  passed full Release compilation with Xcode 27.2 / Swift 6.4.2, signing disabled.
- The application remains in Swift 5 language mode. Imported code emits Swift 6
  migration warnings about AXUIElement captures, actor isolation and ignored
  throwing Task handles; no claim of Swift 6 language-mode readiness is made.
- The native macOS 27 implementation changes system menu-bar preferences. Live
  tests and signing remain separate from compilation; see FORK.md.
- The fork bundle ID is com.romthpt.Ice; upstream updates are disabled.
- SwiftLint and Sparkle archives were checked against their published SHA-256
  digests. All six dependency checkouts match Package.resolved.
- In the managed local environment, Swift package tests used --disable-sandbox
  because nested sandbox-exec is unavailable. The test package has no external
  dependencies and its tests use synthetic fixtures, not desktop APIs.
