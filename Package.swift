// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let enableDeveloperTools = false
let defaultTraits: Set<String> = if enableDeveloperTools {
    ["MapVinaDeveloper"]
} else {
    []
}

let package = Package(
    name: "MapVinaSwiftUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "MapVinaSwiftUI",
            targets: ["MapVinaSwiftUI"]
        ),
        .library(
            name: "MapVinaSwiftDSL",
            targets: ["MapVinaSwiftDSL"]
        ),
        .library(
            name: "MapVinaSwiftMacros",
            targets: ["MapVinaSwiftMacros"]
        ),
    ],
    traits: [
        .default(enabledTraits: defaultTraits),
        .trait(name: "MapVinaDeveloper"),
    ],
    dependencies: [
        .package(url: "https://github.com/mapvina/mapvina-gl-native-distribution.git", from: "1.0.0"),
        // Macros
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "509.0.0" ..< "603.0.0"),
        // Testing
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.1.1"),
        .package(url: "https://github.com/Kolos65/Mockable.git", from: "0.5.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.7"),
        // Macro Testing
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", .upToNextMinor(from: "0.6.4")),
    ],
    targets: [
        .target(
            name: "MapVinaSwiftUI",
            dependencies: [
                .target(name: "InternalUtils"),
                .target(name: "MapVinaSwiftDSL"),
                .product(name: "MapVina", package: "mapvina-gl-native-distribution"),
                .product(name: "Mockable", package: "Mockable", condition: .when(traits: ["MapVinaDeveloper"])),
            ],
            swiftSettings: [
                .define("MOCKING", .when(configuration: .debug)),
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .target(
            name: "MapVinaSwiftDSL",
            dependencies: [
                .target(name: "InternalUtils"),
                .product(name: "MapVina", package: "mapvina-gl-native-distribution"),
                "MapVinaSwiftMacros",
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .target(
            name: "InternalUtils",
            dependencies: [
                .product(name: "MapVina", package: "mapvina-gl-native-distribution"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),

        // MARK: Macro

        .macro(
            name: "MapVinaSwiftMacrosImpl",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "MapVinaSwiftMacros", dependencies: ["MapVinaSwiftMacrosImpl"]),

        // MARK: Tests

        .testTarget(
            name: "MapVinaSwiftUITests",
            dependencies: [
                "MapVinaSwiftUI",
                .product(name: "MapVina", package: "mapvina-gl-native-distribution"),
                .product(name: "Numerics", package: "swift-numerics"),
                .product(name: "Mockable", package: "Mockable"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
        .testTarget(
            name: "MapVinaSwiftDSLTests",
            dependencies: [
                "MapVinaSwiftDSL",
            ]
        ),

        // MARK: Macro Tests

        .testTarget(
            name: "MapVinaSwiftMacrosTests",
            dependencies: [
                "MapVinaSwiftMacrosImpl",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "MacroTesting", package: "swift-macro-testing"),
            ]
        ),
    ],
    swiftLanguageModes: [.v5] // TODO: we need to enable v6
)
