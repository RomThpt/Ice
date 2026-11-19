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
