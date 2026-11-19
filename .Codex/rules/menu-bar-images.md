# Menu bar image failure: issue #9

- Reproduced on macOS 27 with both permissions granted, including after relaunch.
- Item enumeration succeeded, but no ItemImages directory was produced.
- A diagnostic build showed capture returning at the active-display guard.
- A read-only display query returned `Main`; the active display list contained the
  main display. The previous resolver treated every identifier as a UUID.
- Added explicit `Main` resolution and retained UUID matching, with no fallback for
  invalid identifiers or disconnected displays. Six regression tests cover these
  cases, including a secondary display UUID and a non-first main display.
- Validation: 200 tests passed; strict SwiftLint passed; signed Release build passed
  with existing Swift 6 migration warnings; deep/strict signature verification passed.
- Installed 0.11.13-romthpt.2 (1122). Menu Bar Layout visibly showed icons and no
  “Unable to display menu bar items” error. Hidden section was empty as configured.
- Live validation used one built-in display. Multiple-display matching is covered by
  unit tests, not a live multiple-display session. Existing glyph extraction can leave
  background remnants around some icons; this fix addresses failed display resolution.
- Original installed app retained at /private/tmp/Ice-before-images-fix.app.
- Diagnostic logging was removed before the final build.
