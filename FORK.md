# Local development fork

This GPL-3.0 fork combines reliability fixes with experimental macOS 27 support.
It is a development build, not a signed, notarized distribution.
Its bundle identifier is `com.romthpt.Ice`, with a matching XPC service identifier;
its preferences and permissions are separate from the upstream app. The upstream
developer team is not used. Configure a suitable signing identity before live use.

## Sources and review order

The maintenance branches start at jordanbaird/Ice main
`11edd39115f3f43a83ae114b5348df6a0e1741cf`.

The compatibility branch incorporates the source tree of
[upstream PR #995](https://github.com/jordanbaird/Ice/pull/995) at
`889f1ead1fcf79ec74e4314ad107167e17903771`, including its prerequisite macos-26
branch at `6d74d25c33a9ab04307c1f222fbe68ad71847234`. Its scope is larger than
the PR's comparison against macos-26. The imported code retains its copyright
and GPL notices, including the Thaw and Barometer attribution in the assessment
mode implementation. Upstream installation and desktop-test scripts have not
been executed. The installation script is intentionally omitted from this fork.

Review the stacked PRs in issue order: #1 (maintenance), #2 (capture lifetime),
#3 (graceful relaunch), then #4 (compatibility). The compatibility branch contains
all preceding changes. Its legacy capture implementation uses a Swift-managed
pointer array, superseding the manual allocation fixed by #2.

## Verification

Requirements: Xcode 27.2 for the checked configuration, SwiftLint 0.65.1, and
network access for an initial resolution of the pinned Xcode dependencies.

```sh
swiftlint lint --no-cache --strict
swiftlint lint --no-cache --strict Shared MenuBarItemService Tests
swift test --scratch-path build/tests
xcodebuild -resolvePackageDependencies -project Ice.xcodeproj -scheme Ice \
  -derivedDataPath "$PWD/build/ForkDerivedData" \
  -clonedSourcePackagesDirPath "$PWD/build/ForkPackages" \
  -packageCachePath "$PWD/build/spm-cache" \
  -onlyUsePackageVersionsFromResolvedFile
xcodebuild -project Ice.xcodeproj -scheme Ice -configuration Debug \
  -destination 'platform=macOS' -derivedDataPath "$PWD/build/ForkDerivedData" \
  -clonedSourcePackagesDirPath "$PWD/build/ForkPackages" \
  -packageCachePath "$PWD/build/spm-cache" \
  -disableAutomaticPackageResolution -skipPackageUpdates \
  CODE_SIGNING_ALLOWED=NO build
```

The tests exercise production logic with synthetic fixtures. They do not launch
Ice, capture the desktop, modify menu-bar preferences or terminate applications.
Build phases do not install or launch the product. Keep hardened runtime enabled.
The unsigned build product is for compilation verification, not installation.

Updates are disabled until this fork has its own signed release channel. The
About pane links bug reports to this fork. Upstream donation links and credits
remain unchanged.

## Remaining live validation

The macOS 27 port uses private APIs. Its native hiding mode modifies the system's
per-application menu-bar preference and records changes for restoration on quit
or the next launch after a crash. If Ice cannot be relaunched, hidden applications
may need to be re-enabled manually in System Settings > Control Center.

The alternative assessment mode has signing-related limitations: the upstream
author reports that local ad-hoc signatures do not preserve Ice's own items in
the allowlist. The port also offers an explicit action to restart MenuBarAgent;
that action can force-terminate the system menu-bar process. It is not part of
automated verification or the normal application spacing operation.

Before installation is considered ready, validate a correctly signed build with:

- Hiding, revealing and restoring both hidden sections, including quitting Ice.
- Battery, Wi-Fi, clock and Control Center clicks with third-party items nearby.
- Applications launched while hidden; compare upstream reports #1007 and #1014
  against the exact integrated revision rather than assuming they remain fixed.
- Screen changes, multiple displays, notch overflow and sleep/wake.
- Native mode crash recovery and preservation of manually disabled items.
- Accessibility/screen-recording permission behavior and capture indicators.
- Refusing/unsaved applications left running after spacing changes.

Passing the pure tests and compilation does not establish these UI behaviors.
