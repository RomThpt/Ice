// swift-tools-version:6.0
import PackageDescription

// Test-only package; these production files also belong to the Ice Xcode target.
let package = Package(
    name: "IceCore",
    platforms: [.macOS(.v14)],
    targets: [
        .target(
            name: "IceDisplay",
            path: "Shared/Utilities/Displays",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "IceDisplayTests",
            dependencies: ["IceDisplay"],
            path: "Tests/IceDisplayTests",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "IceMacOS27Core",
            path: "Ice/MenuBar/MacOS27/Core",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "IceMacOS27CoreTests",
            dependencies: ["IceMacOS27Core"],
            path: "Tests/IceMacOS27CoreTests",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "IceApplicationLifecycle",
            path: "Ice/Utilities/ApplicationLifecycle",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "IceApplicationLifecycleTests",
            dependencies: ["IceApplicationLifecycle"],
            path: "Tests/IceApplicationLifecycleTests",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
