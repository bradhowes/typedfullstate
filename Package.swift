// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "TypedFullState",
  platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v12)],
  products: [
    .library(
      name: "TypedFullState",
      targets: ["TypedFullState"])
  ],
  targets: [
    .target(
      name: "TypedFullState",
      swiftSettings: [
        .define("APPLICATION_EXTENSION_API_ONLY")
      ],
      linkerSettings: [
        .linkedFramework("AudioToolbox", .none)
      ]
    ),
    .testTarget(
      name: "TypedFullStateTests",
      dependencies: ["TypedFullState"],
      linkerSettings: [
        .linkedFramework("AudioToolbox", .none),
        .linkedFramework("AVFoundation", .none),
        .linkedFramework("Foundation", .none),
        .linkedFramework("XCTest", .none),
      ]
    )
  ]
)
