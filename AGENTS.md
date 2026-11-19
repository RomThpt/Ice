# Ice local fork

This fork maintains Ice, a GPL-3.0 macOS menu bar manager, with reliability fixes
and experimental support for newer macOS releases. Keep upstream attribution.

## Build and verification

- Use Xcode with the SDK required by the branch. The original main branch targets
  macOS 14 and later; that deployment target is not a compatibility guarantee.
- Open `Ice.xcodeproj` and use the `Ice` scheme. For a compilation-only check:
  `xcodebuild -project Ice.xcodeproj -scheme Ice -configuration Debug -destination
  'platform=macOS' -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO build`.
- Inspect build phases before the first build of imported code. A build must not
  copy into Applications, launch Ice, change permissions or alter the live menu bar.
- Run SwiftLint using `.swiftlint.yml`. Keep downloaded verification tools under
  ignored `build/tools`; do not commit binaries or generated Xcode output.
- Run `swift test --scratch-path build/tests` before committing code changes.
  This test-only package exercises production logic without launching Ice.
- Use fake applications for relaunch tests. Never quit real applications in tests.
- Compilation-only products are not signed installation artifacts.
- See `FORK.md` for pinned dependency resolution and the complete build command.
  Xcode's `-packageCachePath` must be absolute; a relative path can silently leave
  package products unresolved.

## Workflow

- Every change belongs to a fork issue and a focused PR with validation evidence.
- Use conventional commits under 72 characters and reference the issue.
- Keep branches short (`fix/*`, `feature/*`, `refactor/*`). When PRs are stacked,
  document their order and rebase the stack when main changes.
- Keep the compatibility PR in draft until the application builds and the live
  validation checklist has been completed on the target system.
- Installation, launching Ice and granting permissions are separate user actions.

## Non-obvious constraints

- Accessibility and screen capture are privileged capabilities. Tests must not
  request either permission or record the desktop.
- Preserve the window-ID pointer representation used by the legacy CoreGraphics
  capture API; it is not an array of Core Foundation objects.
- Spacing changes affect other applications. Never force-terminate them.
- A fork must not silently replace itself with an upstream Sparkle release.
  Keep updates disabled until this fork has its own signed release channel.
- macOS 27 concealment uses private APIs; local ad-hoc signing is insufficient for
  some allowlist behavior. Passing pure unit tests cannot establish UI compatibility.
- WindowServer's active menu bar display identifier can be `Main`, not only a UUID.
  Resolve it against the active display list; do not fall back for unknown identifiers.
- Store generated investigation notes in `.Codex/rules/`, not in this file.
